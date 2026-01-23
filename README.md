# deasy

**Dead Easy YouTube Downloader**

A simple, intuitive wrapper around yt-dlp that makes downloading videos and audio as easy as it should be.

---

## Table of Contents

- [Why deasy Exists](#why-deasy-exists)
- [Philosophy](#philosophy)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage Guide](#usage-guide)
- [Examples](#examples)
- [Technical Details](#technical-details)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Why deasy Exists

yt-dlp is powerful but complex. A simple task like "download this video as MP4" requires remembering format strings, merge options, and various flags. Most users just want to download a video or extract audio without becoming command-line experts.

deasy bridges this gap by providing a natural language interface to yt-dlp's most common use cases.

---

## Philosophy

deasy follows three core principles:

**1. Natural Language Over Flags**
- Instead of `-f 'bestvideo[height<=720]+bestaudio'`, just type `720`
- Instead of `-x --audio-format mp3`, just type `audio`
- No memorization required

**2. Smart Defaults**
- Videos download as MP4 with best quality
- Audio downloads as high-quality MP3
- Playlists are automatically organized into folders
- Single videos are extracted from playlists by default

**3. Progressive Complexity**
- Basic usage is dead simple: `deasy <url>`
- Add options naturally: `deasy audio 720 <url>`
- Order doesn't matter: `deasy 720 audio <url>` works too

---

## Installation

### Prerequisites

deasy requires yt-dlp to be installed on your system.

```bash
# Install yt-dlp
pip install yt-dlp

# Or via your package manager
# Ubuntu/Debian
sudo apt install yt-dlp

# macOS
brew install yt-dlp

# Arch Linux
sudo pacman -S yt-dlp
```

### Installing deasy

**Method 1: Add to Shell Configuration (Recommended)**

Add the deasy function to your shell configuration file:

```bash
# For Bash
echo 'source /path/to/deasy.sh' >> ~/.bashrc
source ~/.bashrc

# For Zsh
echo 'source /path/to/deasy.sh' >> ~/.zshrc
source ~/.zshrc
```

**Method 2: System-wide Installation**

```bash
# Copy to a directory in your PATH
sudo cp deasy.sh /usr/local/bin/deasy
sudo chmod +x /usr/local/bin/deasy
```

**Method 3: User-local Installation**

```bash
# Copy to user bin directory
mkdir -p ~/.local/bin
cp deasy.sh ~/.local/bin/deasy
chmod +x ~/.local/bin/deasy

# Add to PATH if not already
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Quick Start

The most basic usage is simply pasting a URL:

```bash
deasy https://youtube.com/watch?v=dQw4w9WgXcQ
```

This downloads the video in best available quality as MP4.

For audio extraction:

```bash
deasy audio https://youtube.com/watch?v=dQw4w9WgXcQ
```

For playlists:

```bash
deasy playlist https://youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf
```

---

## Usage Guide

### Basic Syntax

```
deasy [what] [quality] [format] <url>
```

All options (`what`, `quality`, and `format`) are optional and can appear in any order. The only required element is the URL.

### Download Types (what)

| Keyword | Aliases | Description |
|---------|---------|-------------|
| `video` | `vid` | Download video (default) |
| `audio` | `mp3`, `music`, `song` | Extract audio only as MP3 |
| `playlist` | `list`, `pl` | Download entire playlist |

### Quality Options

| Keyword | Aliases | Description |
|---------|---------|-------------|
| `best` | `highest`, `max` | Best available quality (default) |
| `1080` | `1080p`, `hd` | 1080p resolution |
| `720` | `720p` | 720p resolution |
| `480` | `480p` | 480p resolution |
| `360` | `360p` | 360p resolution |

### Video Format Options

| Format | Description |
|--------|-------------|
| `mp4` | MP4 container (default, best compatibility) |
| `mkv` | Matroska container (supports more codecs) |
| `webm` | WebM container (web-optimized) |
| `avi` | AVI container (legacy support) |

### Audio Format Options

| Format | Description |
|--------|-------------|
| `mp3` | MP3 format (default, universal compatibility) |
| `m4a` | M4A/AAC format (better quality than MP3) |
| `flac` | FLAC format (lossless, large files) |
| `opus` | Opus format (efficient, high quality) |
| `wav` | WAV format (uncompressed, very large) |

### Smart Features

**Playlist Detection**
When you provide a playlist URL without specifying the `playlist` keyword, deasy will ask if you want to download the entire playlist or just the current video.

**Automatic Organization**
Playlists are automatically downloaded into folders named after the playlist, with files numbered according to their playlist index:

```
My Favorite Playlist/
  01 - First Video.mp4
  02 - Second Video.mp4
  03 - Third Video.mp4
```

**Format Optimization**
- Videos are automatically merged into MP4 format
- Audio is extracted as high-quality MP3 (320kbps equivalent)
- Best available codecs are selected automatically

---

## Examples

### Single Video Downloads

Download best quality video:
```bash
deasy https://youtube.com/watch?v=..
```

Download 720p video:
```bash
deasy 720 https://youtube.com/watch?v=..
deasy video 720 https://youtube.com/watch?v=..
```

Download 1080p video:
```bash
deasy 1080 https://youtube.com/watch?v=..
```

Download as MKV format:
```bash
deasy mkv https://youtube.com/watch?v=..
deasy 720 mkv https://youtube.com/watch?v=..
```

Download as WebM format:
```bash
deasy webm https://youtube.com/watch?v=..
```

### Audio Downloads

Extract audio as MP3:
```bash
deasy audio https://youtube.com/watch?v=..
deasy music https://youtube.com/watch?v=..
```

Extract audio as FLAC (lossless):
```bash
deasy audio flac https://youtube.com/watch?v=..
```

Extract audio as M4A/AAC:
```bash
deasy audio m4a https://youtube.com/watch?v=..
```

Extract audio as Opus:
```bash
deasy audio opus https://youtube.com/watch?v=..
```

### Playlist Downloads

Download entire playlist:
```bash
deasy playlist https://youtube.com/playlist?list=..
```

Download playlist as audio:
```bash
deasy playlist audio https://youtube.com/playlist?list=..
deasy audio playlist https://youtube.com/playlist?list=..
```

Download playlist as FLAC:
```bash
deasy playlist audio flac https://youtube.com/playlist?list=..
```

Download playlist in 720p as MKV:
```bash
deasy playlist 720 mkv https://youtube.com/playlist?list=..
```

### Flexible Syntax

All of these are equivalent:
```bash
deasy audio 720 flac https://youtube.com/watch?v=...
deasy 720 audio flac https://youtube.com/watch?v=...
deasy flac 720 audio https://youtube.com/watch?v=...
deasy 720 flac audio https://youtube.com/watch?v=...
```

Video format examples:
```bash
deasy 1080 mkv https://youtube.com/watch?v=...
deasy mkv 1080 https://youtube.com/watch?v=...
deasy video 1080 mkv https://youtube.com/watch?v=...
```

Note: When conflicting options are given, the last one takes precedence.

---

## Technical Details

### Output Formats

**Video Downloads**
- Container: MP4 (default), MKV, WebM, or AVI
- Video codec: Best available (typically H.264/AVC or VP9)
- Audio codec: Best available (typically AAC or Opus)
- Quality: Selected resolution or best available

**Audio Downloads**
- Format: MP3 (default), M4A/AAC, FLAC, Opus, or WAV
- Quality: Highest available (equivalent to 320kbps for lossy formats)
- Metadata: Preserved from source

**Playlist Organization**
- Folder: Named after playlist title
- Files: `{index} - {title}.{ext}` format
- Index: Zero-padded playlist position

### yt-dlp Integration

deasy constructs and executes yt-dlp commands based on your input:

For video downloads:
```bash
yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" \
       --merge-output-format mkv \
       --no-playlist \
       <url>
```

For audio downloads:
```bash
yt-dlp -x \
       --audio-format flac \
       --audio-quality 0 \
       --no-playlist \
       <url>
```

For playlists:
```bash
yt-dlp -f "bestvideo+bestaudio/best" \
       --merge-output-format mp4 \
       --yes-playlist \
       -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
       <url>
```

### Dependencies

- **yt-dlp**: Required for all functionality
- **ffmpeg**: Required for format conversion and merging (usually installed with yt-dlp)
- **Bash**: Version 4.0 or higher

---

## Troubleshooting

### Common Issues

**"yt-dlp is not installed"**

Install yt-dlp using pip or your system package manager:
```bash
pip install yt-dlp
```

**"No URL found"**

Ensure you're providing a valid URL starting with `http://` or `https://`:
```bash
# Correct
deasy https://youtube.com/watch?v=...

# Incorrect
deasy youtube.com/watch?v=...
```

**Download fails or hangs**

This is usually a yt-dlp issue. Try updating yt-dlp:
```bash
pip install --upgrade yt-dlp
```

**Videos download but audio is missing**

Install or update ffmpeg:
```bash
# Ubuntu/Debian
sudo apt install ffmpeg

# macOS
brew install ffmpeg

# Arch Linux
sudo pacman -S ffmpeg
```

**Permission denied when installing**

For system-wide installation, use sudo:
```bash
sudo cp deasy.sh /usr/local/bin/deasy
sudo chmod +x /usr/local/bin/deasy
```

Or install to user directory without sudo:
```bash
mkdir -p ~/.local/bin
cp deasy.sh ~/.local/bin/deasy
chmod +x ~/.local/bin/deasy
```

### Getting Help

If you encounter an issue not covered here:

1. Check yt-dlp's output for specific error messages
2. Verify your yt-dlp installation: `yt-dlp --version`
3. Test with yt-dlp directly to isolate the issue
4. Check yt-dlp's documentation: https://github.com/yt-dlp/yt-dlp

---

## Advanced Usage

While deasy is designed to be simple, you can still use yt-dlp directly for advanced features:

**Rate limiting:**
```bash
yt-dlp -r 500K <url>
```

**Custom output template:**
```bash
yt-dlp -o "%(uploader)s/%(title)s.%(ext)s" <url>
```

**Subtitles:**
```bash
yt-dlp --write-subs --sub-lang en <url>
```

For these advanced cases, refer to yt-dlp's documentation or use yt-dlp directly.

---

## Contributing

deasy is designed to be simple and maintainable. If you have suggestions for improvement:

1. Ensure the suggestion aligns with the simplicity philosophy
2. Test thoroughly with various URL types
3. Consider backward compatibility
4. Keep the natural language interface intuitive

---

## License

This project is released into the public domain. Use it however you like.

---

## Acknowledgments

deasy is a thin wrapper around the excellent [yt-dlp](https://github.com/yt-dlp/yt-dlp) project. All download functionality is provided by yt-dlp.

---

**Version:** 1.0  
**Last Updated:** January 2026
