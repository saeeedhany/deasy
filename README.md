<p align="center">
  <img src="assets/deasy.png" alt="deasy logo" width="400"/>
</p>

<h3 align="center">Download Easy - A Simple YouTube Downloader</h3>

<p align="center">
  A straightforward wrapper around yt-dlp that makes downloading videos and audio effortless.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0-blue" alt="Version 1.0"/>
  <img src="https://img.shields.io/badge/license-Public%20Domain-green" alt="License"/>
  <img src="https://img.shields.io/badge/shell-bash-orange" alt="Shell"/>
</p>

---

## Overview

**What is deasy?**

deasy is a command-line tool that simplifies YouTube downloads. Instead of memorizing complex yt-dlp commands, you simply type what you want in plain language.

**Why deasy?**

yt-dlp is powerful but has a steep learning curve. Tasks like "download this video as MP4" or "extract audio as MP3" require knowledge of format strings, flags, and options. deasy eliminates this complexity while preserving yt-dlp's power.

**Core Philosophy**

- Natural language over technical flags
- Smart defaults for common tasks
- Minimal learning curve
- Order-independent syntax

---

## Installation

### Quick Install

Download both files and run the installer:

```bash
chmod +x install.sh
./install.sh
```

The installer handles everything automatically:
- Checks and installs dependencies (yt-dlp, ffmpeg)
- Installs deasy to your system
- Configures your shell PATH
- Verifies the installation

For help with the installer:
```bash
./install.sh --help
```

### Manual Install

**Requirements:**
- yt-dlp (required)
- ffmpeg (recommended for format conversion)

**Install dependencies:**
```bash
# Using pip
pip install yt-dlp

# Or your package manager
sudo apt install yt-dlp ffmpeg    # Ubuntu/Debian
brew install yt-dlp ffmpeg        # macOS
sudo pacman -S yt-dlp ffmpeg      # Arch Linux
```

**Install deasy:**
```bash
mkdir -p ~/.local/bin
cp deasy.sh ~/.local/bin/deasy
chmod +x ~/.local/bin/deasy
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Basic Usage

The simplest way to use deasy:

```bash
deasy <url>
```

This downloads the video in best quality as MP4.

---

## Options

### Download Type

| Keyword | Effect |
|---------|--------|
| `video` | Download video (default) |
| `audio` | Extract audio only |
| `playlist` | Download entire playlist |

### Quality

| Keyword | Resolution |
|---------|-----------|
| `best` | Highest available (default) |
| `1080` | 1080p |
| `720` | 720p |
| `480` | 480p |
| `360` | 360p |

### Video Formats

| Format | Description |
|--------|-------------|
| `mp4` | Best compatibility (default) |
| `mkv` | More codec support |
| `webm` | Web-optimized |
| `avi` | Legacy support |

### Audio Formats

| Format | Description |
|--------|-------------|
| `mp3` | Universal compatibility (default) |
| `m4a` | Better quality than MP3 |
| `flac` | Lossless quality |
| `opus` | High efficiency |
| `wav` | Uncompressed |

---

## Examples

### Video Downloads

```bash
# Best quality video
deasy https://youtube.com/watch?v=dQw4w9WgXcQ

# Specific quality
deasy 720 https://youtube.com/watch?v=dQw4w9WgXcQ

# Different format
deasy mkv https://youtube.com/watch?v=dQw4w9WgXcQ

# Quality and format
deasy 1080 mkv https://youtube.com/watch?v=dQw4w9WgXcQ
```

### Audio Downloads

```bash
# Extract as MP3
deasy audio https://youtube.com/watch?v=dQw4w9WgXcQ

# Extract as FLAC
deasy audio flac https://youtube.com/watch?v=dQw4w9WgXcQ

# Extract as high-quality M4A
deasy audio m4a https://youtube.com/watch?v=dQw4w9WgXcQ
```

### Playlist Downloads

```bash
# Download playlist
deasy playlist https://youtube.com/playlist?list=PLxxx

# Playlist as audio
deasy playlist audio https://youtube.com/playlist?list=PLxxx

# Playlist with quality
deasy playlist 720 https://youtube.com/playlist?list=PLxxx

# Playlist audio as FLAC
deasy playlist audio flac https://youtube.com/playlist?list=PLxxx
```

### Flexible Syntax

Options can appear in any order:

```bash
# All of these work identically
deasy 720 mkv https://youtube.com/watch?v=...
deasy mkv 720 https://youtube.com/watch?v=...
deasy video 720 mkv https://youtube.com/watch?v=...
```

---

## How It Works

### Smart Parsing

deasy analyzes your command and determines what you want:
- Recognizes quality keywords (720, 1080, etc.)
- Detects format preferences (mp4, mkv, flac, etc.)
- Identifies download type (video, audio, playlist)
- Extracts the URL

### Automatic Organization

Playlists are organized into folders:
```
Playlist Name/
  01 - First Video.mp4
  02 - Second Video.mp4
  03 - Third Video.mp4
```

### Smart Defaults

- Videos: Best quality MP4 with best available codecs
- Audio: High-quality MP3 (320kbps equivalent)
- Single videos from playlist URLs (unless specified otherwise)

### yt-dlp Integration

deasy constructs optimized yt-dlp commands:

**Video example:**
```bash
yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" \
       --merge-output-format mkv \
       --no-playlist \
       <url>
```

**Audio example:**
```bash
yt-dlp -x \
       --audio-format flac \
       --audio-quality 0 \
       --no-playlist \
       <url>
```

---

## Troubleshooting

### yt-dlp not found

Install yt-dlp:
```bash
pip install yt-dlp
# or
sudo apt install yt-dlp
```

### deasy command not found

Add to your PATH or restart your terminal:
```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.bashrc
```

### Format conversion fails

Install ffmpeg:
```bash
sudo apt install ffmpeg    # Ubuntu/Debian
brew install ffmpeg        # macOS
sudo pacman -S ffmpeg      # Arch Linux
```

### Download fails

Update yt-dlp:
```bash
pip install --upgrade yt-dlp
```

---

## Advanced Features

### Playlist Detection

When you provide a playlist URL without the `playlist` keyword, deasy asks if you want the whole playlist or just the current video.

### Custom Output Location

Downloads go to your current directory by default. Change directory before running deasy:
```bash
cd ~/Videos
deasy https://youtube.com/watch?v=...
```

### Using yt-dlp Directly

For advanced features not covered by deasy, use yt-dlp directly:
```bash
# Subtitles
yt-dlp --write-subs --sub-lang en <url>

# Rate limiting
yt-dlp -r 500K <url>

# Custom output template
yt-dlp -o "%(uploader)s/%(title)s.%(ext)s" <url>
```

Refer to yt-dlp documentation for more options: https://github.com/yt-dlp/yt-dlp

---

## Uninstalling

Using the installer:
```bash
./install.sh --uninstall
```

Manual removal:
```bash
rm ~/.local/bin/deasy
```

Remove the PATH entry from your shell config if desired.

---

## License

Released into the public domain. Use freely.

---

## Credits

Built on top of [yt-dlp](https://github.com/yt-dlp/yt-dlp). All download functionality provided by yt-dlp.

---

**Version:** 1.0  
**Updated:** January 2026
