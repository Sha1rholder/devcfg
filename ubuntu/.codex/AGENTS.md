Use hard tabs for indentation unless project explicitly specifies space indentation.

Do not introduce hard wrap solely to satisfy column limit, especially for comment/docstring.

All functions must have docstrings.

Keep comments as concise as possible.

---

When needing to store temporary files, use a folder named `temp/`.

---

Use Simplified Chinese for communicating with user and writing comment/docstring, but avoid having programs output non-ASCII characters by default.

Do not add space between Chinese characters and
- English words (excluding file paths)
- backticks
- numbers

Omit `。` at end of paragraphs and docstrings.

---

User uses Nushell by default.

Always use `uv` to invoke Python.
