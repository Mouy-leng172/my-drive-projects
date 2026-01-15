#!/usr/bin/env python3
"""Extract text from PDFs and images (OCR), then clean it.

- PDFs: uses pdftotext; if extracted text is too small, falls back to OCR via pdftoppm + tesseract.
- Images: OCR via tesseract.
- Cleans output: normalizes newlines, trims trailing spaces, collapses excessive blank lines,
  removes common OCR artifacts (null bytes, soft hyphens), and joins hyphenated line breaks.

Designed to work without Python third-party packages.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path


IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".tif", ".tiff", ".bmp", ".gif"}
SKIP_DIR_NAMES = {
    ".git",
    ".cursor",
    "node_modules",
    "dist",
    "build",
    "__pycache__",
    ".venv",
    "venv",
    "extracted_text",
    "text_extraction",
}


@dataclass(frozen=True)
class ExtractResult:
    source: Path
    method: str
    text: str


def _run(cmd: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        check=check,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )


def _command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def _read_prefix(path: Path, n: int = 32) -> bytes:
    try:
        with path.open("rb") as f:
            return f.read(n)
    except OSError:
        return b""


def _is_pdf(path: Path) -> bool:
    if path.suffix.lower() == ".pdf":
        return True
    return _read_prefix(path, 8).startswith(b"%PDF-")


def _sniff_image_type(path: Path) -> str | None:
    # Minimal magic number checks for extensionless images.
    b = _read_prefix(path, 16)
    if b.startswith(b"\x89PNG\r\n\x1a\n"):
        return "png"
    if b.startswith(b"\xff\xd8\xff"):
        return "jpeg"
    if b.startswith(b"GIF87a") or b.startswith(b"GIF89a"):
        return "gif"
    if b.startswith(b"RIFF") and b[8:12] == b"WEBP":
        return "webp"
    if b.startswith(b"BM"):
        return "bmp"
    if b.startswith(b"II*\x00") or b.startswith(b"MM\x00*"):
        return "tiff"
    return None


def _is_image(path: Path) -> bool:
    if path.suffix.lower() in IMAGE_EXTS:
        return True
    return _sniff_image_type(path) is not None


def clean_text(text: str) -> str:
    # Normalize line endings
    text = text.replace("\r\n", "\n").replace("\r", "\n")

    # Remove null bytes / soft hyphens
    text = text.replace("\x00", "")
    text = text.replace("\u00ad", "")

    # Join hyphenated line breaks (common in PDFs / OCR)
    text = re.sub(r"([A-Za-z])\-\n([a-z])", r"\1\2", text)

    # Trim trailing whitespace
    text = re.sub(r"[ \t]+\n", "\n", text)

    # Collapse excessive blank lines
    text = re.sub(r"\n{3,}", "\n\n", text)

    return text.strip() + "\n"


def extract_pdf_text(pdffile: Path) -> ExtractResult:
    if not _command_exists("pdftotext"):
        raise RuntimeError("pdftotext not found; install poppler-utils")

    proc = _run(["pdftotext", "-layout", "-enc", "UTF-8", str(pdffile), "-"]) 
    text = proc.stdout or ""
    return ExtractResult(source=pdffile, method="pdftotext", text=text)


def ocr_image(imagefile: Path, *, lang: str) -> ExtractResult:
    if not _command_exists("tesseract"):
        raise RuntimeError("tesseract not found; install tesseract-ocr")

    # Use stdout output mode.
    proc = _run(
        [
            "tesseract",
            str(imagefile),
            "stdout",
            "-l",
            lang,
            "--oem",
            "1",
            "--psm",
            "3",
        ]
    )
    return ExtractResult(source=imagefile, method=f"tesseract({lang})", text=proc.stdout or "")


def ocr_pdf(pdffile: Path, *, lang: str, dpi: int) -> ExtractResult:
    if not _command_exists("pdftoppm"):
        raise RuntimeError("pdftoppm not found; install poppler-utils")
    if not _command_exists("tesseract"):
        raise RuntimeError("tesseract not found; install tesseract-ocr")

    with tempfile.TemporaryDirectory(prefix="pdf_ocr_") as td:
        out_prefix = str(Path(td) / "page")
        _run(["pdftoppm", "-r", str(dpi), "-png", str(pdffile), out_prefix])

        pages = sorted(Path(td).glob("page-*.png"), key=lambda p: p.name)
        if not pages:
            return ExtractResult(source=pdffile, method="pdf_ocr(no_pages)", text="")

        parts: list[str] = []
        for p in pages:
            parts.append(ocr_image(p, lang=lang).text)

        return ExtractResult(source=pdffile, method=f"pdftoppm({dpi})+tesseract({lang})", text="\n\n".join(parts))


def should_fallback_to_ocr(text: str, *, min_chars: int) -> bool:
    # If the extracted text is tiny, it's likely a scanned PDF.
    # Also consider the amount of alphanumeric content.
    cleaned = clean_text(text)
    if len(cleaned) < min_chars:
        return True
    alnum = sum(1 for c in cleaned if c.isalnum())
    return alnum < max(20, min_chars // 4)


def ensure_parent_dir(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def output_path_for(source: Path, *, workspace_root: Path, out_dir: Path) -> Path:
    try:
        rel = source.relative_to(workspace_root)
    except ValueError:
        rel = Path(source.name)

    if rel.suffix:
        rel = rel.with_suffix(".txt")
    else:
        rel = Path(str(rel) + ".txt")

    return out_dir / rel


def iter_candidate_files(input_roots: list[Path]) -> list[Path]:
    out: list[Path] = []

    # Directory name hints where extensionless images may exist.
    likely_image_dir_tokens = {"images", "image", "picture", "pictures", "photo", "photos", "pdf", "scans", "scan"}

    for root in input_roots:
        if root.is_file():
            out.append(root)
            continue
        if not root.exists():
            continue

        for dirpath, dirnames, filenames in os.walk(root):
            # Skip noisy dirs
            dirnames[:] = [d for d in dirnames if d not in SKIP_DIR_NAMES]

            dpath = Path(dirpath)
            dir_hint = any(part.lower() in likely_image_dir_tokens for part in dpath.parts)

            for fn in filenames:
                p = dpath / fn
                suf = p.suffix.lower()

                if suf == ".pdf":
                    out.append(p)
                    continue

                if suf in IMAGE_EXTS:
                    out.append(p)
                    continue

                # Only sniff extensionless / unknown files in likely image folders.
                if suf == "" and dir_hint:
                    if _is_image(p):
                        out.append(p)

    # Deduplicate
    seen: set[Path] = set()
    uniq: list[Path] = []
    for p in out:
        if p not in seen:
            uniq.append(p)
            seen.add(p)
    return sorted(uniq)


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description="Extract and clean text from PDFs and images")
    ap.add_argument(
        "--input",
        action="append",
        default=[],
        help="Input file/folder (repeatable). Default: projects/ and Document,sheed,PDF, PICTURE/ under workspace root.",
    )
    ap.add_argument("--workspace-root", default=str(Path.cwd()), help="Workspace root for relative output paths")
    ap.add_argument("--out", default=str(Path.cwd() / "extracted_text"), help="Output directory")
    ap.add_argument("--lang", default="eng", help="Tesseract language (default: eng)")
    ap.add_argument("--dpi", type=int, default=300, help="DPI for PDF -> image rasterization (default: 300)")
    ap.add_argument("--min-pdf-chars", type=int, default=200, help="If PDF text shorter than this, OCR is attempted")
    ap.add_argument(
        "--combine",
        action="store_true",
        help="Also write combined output file ALL_EXTRACTED_TEXT.txt in output dir",
    )
    args = ap.parse_args(argv)

    workspace_root = Path(args.workspace_root).resolve()
    out_dir = Path(args.out).resolve()

    input_roots: list[Path]
    if args.input:
        input_roots = [Path(p).resolve() for p in args.input]
    else:
        # Sensible defaults for this repo.
        input_roots = []
        for p in [workspace_root / "projects", workspace_root / "Document,sheed,PDF, PICTURE"]:
            if p.exists():
                input_roots.append(p)
        if not input_roots:
            input_roots = [workspace_root]

    candidates = iter_candidate_files(input_roots)
    if not candidates:
        print("No PDFs/images found under inputs.")
        return 0

    out_dir.mkdir(parents=True, exist_ok=True)

    combined_parts: list[str] = []

    for src in candidates:
        try:
            if _is_pdf(src):
                base = extract_pdf_text(src)
                text = base.text
                method = base.method

                if should_fallback_to_ocr(text, min_chars=args.min_pdf_chars):
                    ocr = ocr_pdf(src, lang=args.lang, dpi=args.dpi)
                    text = ocr.text
                    method = ocr.method

            elif _is_image(src):
                ocr = ocr_image(src, lang=args.lang)
                text = ocr.text
                method = ocr.method
            else:
                continue

            cleaned = clean_text(text)
            out_path = output_path_for(src, workspace_root=workspace_root, out_dir=out_dir)
            ensure_parent_dir(out_path)
            out_path.write_text(cleaned, encoding="utf-8")

            print(f"[OK] {src} -> {out_path} ({method})")

            if args.combine:
                combined_parts.append(
                    "\n".join(
                        [
                            "=" * 80,
                            f"SOURCE: {src}",
                            f"METHOD: {method}",
                            "=" * 80,
                            cleaned,
                        ]
                    )
                )

        except Exception as e:
            print(f"[ERROR] {src}: {e}", file=sys.stderr)

    if args.combine and combined_parts:
        combined_path = out_dir / "ALL_EXTRACTED_TEXT.txt"
        combined_path.write_text("\n\n".join(combined_parts).strip() + "\n", encoding="utf-8")
        print(f"[OK] Combined -> {combined_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
