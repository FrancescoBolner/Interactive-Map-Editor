════════════════════════════════════════════════════════════════════════════════
                         🗺️  INTERACTIVE MAP EDITOR
════════════════════════════════════════════════════════════════════════════════

Version: 1.4 | Author: Francesco Bolner | Updated: January 2026

A powerful HTML5 Canvas-based map editor for creating hierarchical, zoomable
maps with interactive markers and spatial audio. Perfect for RPG campaigns,
game development, or any multi-scale visualization project.

WHAT MAKES THIS UNIQUE:
  • Infinite zoom with scale-dependent layer visibility
  • Hierarchical parent-child image relationships
  • Seven marker types with filtering (including enemy/boss tracking)
  • Rectangular audio zones with automatic priority handling
  • Built-in asset gallery with folder organization
  • Auto-save support (Chrome/Edge) or manual export/import
  • Pure JavaScript - no dependencies, no build process


════════════════════════════════════════════════════════════════════════════════
📑 TABLE OF CONTENTS
════════════════════════════════════════════════════════════════════════════════

  1.  QUICK START ........................ Get running in 2 minutes
  2.  CORE CONCEPTS ...................... Understanding the system
  3.  NAVIGATION ......................... Mouse, touchpad, touchscreen
  4.  EDIT MODE OVERVIEW ................. Interface and workflow
  5.  IMAGES (Hierarchical Layers) ....... Creating zoomable maps
  6.  MARKS (Interactive Markers) ........ Points of interest
  7.  SOUNDS (Spatial Audio) ............. Location-based audio
  8.  GALLERY (Asset Management) ......... Organizing resources
  9.  AUTO-SAVE & DATA MANAGEMENT ........ Persisting your work
  10. CONFIGURATION REFERENCE ............ JSON structure
  11. TIPS & BEST PRACTICES .............. Performance & workflow
  12. TROUBLESHOOTING .................... Common issues
  13. TECHNICAL REFERENCE ................ Browser support, limitations
  14. VERSION HISTORY .................... Previous versions
  15. CONTACT ............................ Bug reports & support
  16. LICENSE ............................ Apache License 2.0

════════════════════════════════════════════════════════════════════════════════
1. QUICK START
════════════════════════════════════════════════════════════════════════════════

REQUIREMENTS
────────────
  ✓ Modern browser (Chrome/Edge recommended for full features)
  ✓ No external dependencies needed

OPTION A: Windows Quick Launch (Recommended)
─────────────────────────────────────────────
  1. Double-click launcher.bat
  2. Chrome opens automatically with --disable-web-security flag
  3. Start editing!
  
  This opens index.html directly via file:// protocol with security disabled,
  allowing the app to read data/map-data.json without a local server.
  
  ⚠️  WARNING: A temporary Chrome session is created. Only use this browser
      window for the map editor - do not browse other sites!

OPTION B: Manual Setup with HTTP Server (Any OS)
─────────────────────────────────────────────────
  1. Open terminal in the this folder
  2. Start HTTP server:
    - Python:  python -m http.server 8000
    - Node:    npx http-server -p 8000
    - PHP:     php -S localhost:8000
  3. Open browser to: http://localhost:8000
  4. Ctrl+C or close the terminal to terminate the server

OPTION C: Direct File Open + Upload
─────────────────────────────────────
  1. Open index.html directly in any browser (file://)
  2. The app will start with an empty map (JSON loading fails)
  3. Click "Edit Mode" → scroll to "Data Management" → "Upload JSON"
  4. Select your existing map-data.json file to load it
  
  This works in any browser without security workarounds, but requires
  manual upload each time you open the file.

FIRST STEPS
───────────
  1. Click "Edit Mode" button (top-left)
  2. Switch to Image tab → Add your first map layer
  3. Switch to Mark tab → Add interactive markers
  4. Click "💾 Auto" button → Select save location (Chrome/Edge only)
  5. Toggle Edit Mode off to test navigation

Your map auto-loads from data/map-data.json on startup if it exists.

════════════════════════════════════════════════════════════════════════════════
2. CORE CONCEPTS
════════════════════════════════════════════════════════════════════════════════

HIERARCHICAL ZOOM SYSTEM
─────────────────────────
Think Google Maps, but for your custom worlds:

  Scale 1.0 (zoomed out)  →  World Map visible
  Scale 3.0               →  Continent Map appears, World fades
  Scale 10.0              →  City Map appears, Continent fades  
  Scale 50.0 (zoomed in)  →  Building Interior appears

Each image defines appear scale (when it appears).
This creates smooth zoom-dependent layer transitions.

PARENT-CHILD RELATIONSHIPS
──────────────────────────
Images can be parents to other images:
  
  • Child are RELATIVE to parent
  • Children only visible when parent is visible
  • Moving parent moves all children with it
  • Enables complex nested structures

Example hierarchy:
  World (parent: none, minScale: 0)
  └─ Kingdom (parent: World, minScale: 5)
     └─ City (parent: Kingdom, minScale: 15)
        └─ Castle (parent: City, minScale: 40)

MARKS: TWO TYPES
────────────────
  Node Marks:    Attached to specific images (relative coordinates)
                 → Move with parent, inherit visibility
                 → Good for: Room details, city features

  General Marks: Standalone at fixed world coordinates
                 → Always visible (or attached to image parent)
                 → Good for: Major landmarks, quest locations

SPATIAL AUDIO ZONES
───────────────────
Rectangular areas that trigger looping audio when the viewport center enters:
  
  • Scale-dependent: Only play within zoom range
  • Priority system: Higher appear scale = higher priority
  • Only one sound plays at a time

ASSET GALLERY
─────────────
Centralized library for reusable images and sounds:
  
  • Folder organization (nested folders supported)
  • Reference counting (see what's in use)
  • Drag-and-drop uploads
  • Gallery items stored as base64 in JSON

════════════════════════════════════════════════════════════════════════════════
3. NAVIGATION
════════════════════════════════════════════════════════════════════════════════

The application auto-detects your input method and optimizes behavior:

MOUSE NAVIGATION
────────────────
  Pan:   Click and drag canvas
  Zoom:  Scroll wheel (10% per tick)
         • Scroll up = zoom in
         • Scroll down = zoom out
         • Zoom centers on cursor position

TOUCHPAD NAVIGATION
───────────────────
  Pan:   Two-finger scroll (horizontal or vertical)
         • Speed scales with zoom (faster when zoomed out)
         • Zero sensitivity threshold (responsive to small movements)
  
  Zoom:  Ctrl + Scroll OR Pinch gesture (OS-dependent)
         • 7.5% per tick (slower than mouse for precision)
         • Zoom centers on cursor position

TOUCHSCREEN NAVIGATION
──────────────────────
  Pan:   One-finger drag
  Zoom:  Two-finger pinch
         • Zoom centers on midpoint between fingers
         • Smooth distance-based scaling

  Note: Three or more fingers → only first two used

VIEW CONTROLS (Top-Right)
─────────────────────────
  📍/👺/🗺️  Mark Visualizer Button (cycles through 4 modes):
            • 📍 Land marks only (dots, cities, dungeons, etc.)
            • 👺 Enemy marks only (boss encounters)
            • 🗺️ All marks visible
            • 📍 (faded) No marks

  🔊/🔇     Sound Toggle:
            • ON: Plays audio when entering zones
            • OFF: Stops all audio immediately

  x: Y: Z:  Debug Info (position and zoom scale)

════════════════════════════════════════════════════════════════════════════════
4. EDIT MODE OVERVIEW
════════════════════════════════════════════════════════════════════════════════

ACTIVATION
──────────
Click "Edit Mode" button (top-left) → Sidebar slides in from left

INTERFACE LAYOUT
────────────────
  Top Buttons:
    • 💾 Auto - Enable auto-save (Chrome/Edge only)
    • 🪲 - Bug report email link

  Four Mode Tabs:
    • 🖼️ Image - Add/edit hierarchical map layers
    • 📍 Mark - Add/edit interactive markers
    • 🔊 Sound - Add/edit audio zones
    • 🗂️ Gallery - Manage asset library

  Each tab contains:
    1. Info text explaining the mode
    2. Form for adding/editing items
    3. Management list (search, edit, delete, reorder)

  Bottom Section:
    • Data Management (Download/Upload JSON)

WORKFLOW
────────
  Add:      Fill form → Click "Add [Type]" button
  Edit:     Click item in list OR click element on canvas → Modify → "Update"
  Delete:   Click trash icon in management list
  Reorder:  Drag items by ⋮⋮ handle
  Search:   Type in search box to filter lists

CLICK-TO-EDIT
─────────────
In Edit Mode, clicking canvas elements loads them into the form:
  
  • Images: Click anywhere on the image
  • Marks: Click within 15px of marker (screen space)
  • Sounds: Click inside the zone rectangle

Note: Select the matching tab first (e.g., Image tab to edit images).

SPECIAL FEATURES
────────────────
  • Real-time preview: See changes as you edit
  • Form validation: Required fields marked with *
  • Success messages: Confirm operations (auto-hide after 3 seconds)
  • Pick buttons: Click canvas to auto-fill coordinates

════════════════════════════════════════════════════════════════════════════════
5. IMAGES (Hierarchical Layers)
════════════════════════════════════════════════════════════════════════════════

Images form the foundation of your map - they can be standalone or hierarchical.

ADDING AN IMAGE
───────────────

[Name] (Optional)
  Human-readable identifier
  Example: "Kingdom of Eldoria", "Tavern Interior"
  Used in: Management lists, parent dropdowns

[URL] (Required)
  Image source - four options:
  
  1. Relative path:     img/world-map.png
  2. Absolute URL:      https://example.com/map.jpg
  3. Gallery reference: Select via "🖼️ Open Gallery" button
  4. Base64 data URI:   Drag & drop file onto upload area

  Drag & Drop Upload:
    • Drag image onto upload area OR click to browse
    • File is saved to gallery root folder
    • Shows preview thumbnail + file info
    • Pro: Portable, reusable (no external files needed)
    • Con: Bloats JSON size (~33% larger than original)

[Position X, Y] (Required)
  Center point in world coordinates
  
  • Units: Arbitrary (suggest pixels for 1:1 at scale 1.0)
  • Origin: (0, 0) = canvas center
  • Axes: +X right, -X left, +Y down, -Y up
  • Pick button: Click canvas to auto-fill current cursor position
  • Coordinates are always absolute (world space)

[Appear Scale] (Required)
  Minimum zoom level for image to appear
  
  • 0 = always visible when zoomed out
  • Higher values = appears only when zoomed in
  • Examples:
      Scale: 0 → World map (base layer)
      Scale: 5 → Continent (appears at 5x zoom)
      Scale: 20 → City (appears at 20x zoom)

[Size] (Required)
  Display dimensions in world units
  
  • Relative to actual image dimensions (aspect ratio preserved)
  • Examples at scale 1.0:
      Width: 1000, Height: 600 → image is 1000×600 screen pixels
      Width: 500, Height: 500 → image is 500×500 screen pixels

[Parent] (Optional)
  Link to parent image for hierarchical nesting
  
  • "None" = root level (top of hierarchy)
  • Select parent = child of that image
  
  Child behavior:
    • Only visible when parent is visible
    • Inherits parent's zoom constraints
  
  ⚠️  WARNING: Avoid circular references (A→B→C→A)
  ⚠️  WARNING: Don't select self as parent

OPERATIONS
──────────

Add:
  Fill form → "Add Image" button
  → Image appears on canvas
  → Added to config array (or parent.children if parent selected)

Edit:
  Click image on canvas OR click edit icon in list
  → Form populates with data
  → Button changes to "Update Image"
  → Modify fields → "Update Image" → Saves changes

Delete:
  Click trash icon in list
  → Confirmation dialog
  → Deletes image AND all descendants (recursive)
  → Orphans any marks attached to deleted images

Reorder:
  Drag by ⋮⋮ handle in list
  → Changes rendering order (last rendered = on top)
  → Only reorders siblings (same parent)
  → Affects click detection priority

MANAGEMENT LIST
───────────────
Located below the form:

  • Hierarchical tree view (expandable parents)
  • Shows: Indentation, name
  • Search: Filters by name
    ☐ Show children checkbox: Include nested images in search
  • Drag handles: Reorder items
  • Edit button: Load into form
  • Delete button: Remove (with confirmation)

TIPS
────
  • Progressive scales: Use 0, 3, 6, 9, 12... for smooth transitions
  • Reasonable sizes: Very large images (>10MB) may cause lag
  • External files: Better performance than base64 for large images
  • Test zoom ranges: Verify no gaps or unexpected overlaps

════════════════════════════════════════════════════════════════════════════════
6. MARKS (Interactive Markers)
════════════════════════════════════════════════════════════════════════════════

Marks are interactive points of interest with hover tooltips.

SEVEN MARK TYPES
────────────────
  
  dot       🔴 Generic location marker
  city      🏰 Towns, settlements, capitals
  dungeon   🕳️  Caves, underground areas
  fight     ⚔️  Battle sites, arenas
  treasure  💎 Loot locations, rewards
  landmark  🚩 Notable features, monuments
  enemy     👺 Boss encounters, monster lairs

Icons are 24×24px SVG files in mark/ folder (can be customized).

MARK TYPES: NODE VS GENERAL
────────────────────────────

Node Marks (attached to images):
  • Position relative to parent image center
  • Stored in: image.marks[] array
  • Visibility: Inherits parent's visibility rules
  • Use case: Room features, city details

General Marks (standalone):
  • Position in absolute world coordinates (or relative if parent selected)
  • Stored in: generalMarks[] array
  • Visibility: Always visible (or follows parent if attached)
  • Use case: Major landmarks, quest markers

ADDING A MARK
─────────────

[Type] (Required)
  Select mark icon:
  dot, city, dungeon, fight, treasure, landmark, enemy

[Name] (Required)
  Title shown in tooltip (bold, first line)
  If it's a node mark takes the image's name
  Example: "Dragon's Lair", "Ancient Temple"

[Description] (Optional)
  Details shown in tooltip (below name)
  Supports multiline (line breaks preserved)
  Plain text only (no HTML/Markdown)

[Position X, Y] (Required)
  Marker coordinates
  
  • Pick button: Click canvas to auto-fill
  • For general marks: World coordinates
  • For node marks: Offset from parent image center (automatic)

[Parent] (Optional)
  Attach mark to specific image
  
  • "General" = always visible
  • Select image = only visible when parent is visible
  
  Note: Changing parent type converts coordinates automatically

MARK VISUALIZER
───────────────
Button in top-right corner (📍/👺/🗺️) cycles through 4 modes:

  Mode 0 (📍): Land marks only
               Shows: dot, city, dungeon, fight, treasure, landmark
               Hides: enemy

  Mode 1 (👺): Enemy marks only
               Shows: enemy
               Hides: all others

  Mode 2 (🗺️):  All marks visible
               Shows: everything

  Mode 3 (📍 faded): No marks
               Hides: everything

Purpose: Focus on different marker types during gameplay or editing

OPERATIONS
──────────

Add:
  Fill form → "Add Mark" button
  → Mark appears on canvas
  → Coordinates auto-adjusted based on parent type

Edit:
  Click mark on canvas OR edit icon in list
  → Form populates
  → Button becomes "Update Mark"
  → Modify → "Update Mark"
  → Handles parent type changes (converts coordinates)

Delete:
  Click trash icon
  → Confirmation dialog
  → Deletes mark

Reorder:
  Drag by ⋮⋮ handle
  → Changes rendering/click priority
  → Cannot reorder across node/general boundary

MANAGEMENT LIST
───────────────
  • Grouped by parent (By image first, then general)
  • Shows: Name, position
  • Search: Filters name
  • Click mark on canvas or in list to edit

TIPS
────
  • Enemy marks: Great for tracking boss encounters, can filter separately
  • Parent linking: Use for context-specific markers
  • Tooltips: Keep descriptions concise (long text may overflow screen)
  • Position precision: Zoom in before using Pick button for accuracy

════════════════════════════════════════════════════════════════════════════════
7. SOUNDS (Spatial Audio)
════════════════════════════════════════════════════════════════════════════════

Rectangular zones that play looping audio based on viewport position and zoom.

AUDIO BEHAVIOR
──────────────

Playback triggers when ALL conditions met:
  1. Sound toggle enabled (🔊 button)
  2. Viewport center inside zone rectangle
  3. Current zoom scale >= sound's min scale
  4. Current zoom scale <= sound's max scale (if set)
  5. User has interacted with page (browser autoplay policy)

Playback characteristics:
  • Volume: Fixed 30% (not adjustable - edit audio file to change volume)
  • Loop: Continuous while in zone
  • Transitions: Instant start/stop (no fade)
  • Priority: Higher min scale sound plays (if zones overlap)

ADDING A SOUND
──────────────

[Name] (Optional)
  Display name (shown in zone labels and lists)
  Example: "Forest Ambience", "Town Music"

[URL] (Required)
  Audio source - four options:
  
  1. Relative path:     sound/forest-ambience.mp3
  2. Absolute URL:      https://example.com/audio.ogg
  3. Gallery reference: Select via "🎵 Open Gallery" button
  4. Base64 data URI:   Drag & drop file onto upload area

  Format recommendations:
    • MP3: Best browser compatibility
    • OGG: Good compression, not IE11
    • WAV: Uncompressed, very large files
    • M4A: Good quality, variable support

  Drag & Drop Upload:
    • Same as images (converts to base64)
    • WARNING: Audio files can be very large
    • 10MB audio → ~13MB base64 → bloats JSON significantly
    • Recommendation: Use gallery or external files for audio

[Zone Corner 1 X, Y] (Required)
  First corner of rectangular zone
  Pick button: Click canvas to set coordinates

[Zone Corner 2 X, Y] (Required)
  Opposite corner of rectangular zone
  Pick button: Click canvas to set coordinates
  
  Notes:
    • Corners can be in any order (auto-normalized)
    • Rectangle is axis-aligned (no rotation)
    • Visual zone outline shown in Edit Mode

[Min Scale] (Required)
  Minimum zoom level for playback
  
  • 0 = plays at all zoom levels
  • Higher values = only plays when zoomed in
  • ALSO determines priority (see below)

[Max Scale] (Optional)
  Maximum zoom level for playback
  
  • Empty = no limit (plays at all high zoom levels)
  • Use to stop sound when zooming too far in

PRIORITY SYSTEM
───────────────
When multiple sound zones overlap, priority determined by min scale:

  First matching zone plays (HIGHER min scale = HIGHER priority)

Example at scale 10:
  Zone A (min scale: 0, in range)   ← Priority 3 (lowest)
  Zone B (min scale: 5, in range)   ← Priority 2
  Zone C (min scale: 8, in range)   ← Priority 1 (highest) → PLAYS

This ensures "closer" sounds (higher zoom = closer = higher min scale) override 
distant ambient sounds.

Manual priority control: Reorder sounds in management list (first = highest 
priority when min scale values equal).

OPERATIONS
──────────

Add:
  Fill form → "Add Sound" button
  → Zone appears on canvas (colored rectangle with label)
  → Format: "Name (min-max)" or "Name (min+)"

Edit:
  Click inside zone on canvas OR edit icon in list
  → Form populates
  → Button becomes "Update Sound"
  → Zone highlighted with red outline
  → Modify → "Update Sound"

Delete:
  Click trash icon → Confirmation dialog
  → Stops audio if currently playing

Reorder:
  Drag by ⋮⋮ handle
  → Changes priority for overlapping zones

MANAGEMENT LIST
───────────────
  • Shows: Name
  • Search: Filters by name
  • Edit/delete buttons
  • Drag handles for reordering

TIPS
────
  • Seamless loops: Ensure audio files loop smoothly (no clicks)
  • MP3 format: Best compatibility across browsers
  • Small files: Compress audio (64-128kbps adequate for ambient)
  • User interaction: Click page first (browser autoplay policy)
  • Testing: Enable sound toggle (🔊) and check scale range

════════════════════════════════════════════════════════════════════════════════
8. GALLERY (Asset Management)
════════════════════════════════════════════════════════════════════════════════

Centralized library for organizing and reusing images and sounds.

OPENING THE GALLERY
───────────────────
  • Click "🖼️ Open Gallery" button (Image Mode)
  • Click "🎵 Open Gallery" button (Sound Mode)  
  • Click 🗂️ Gallery tab (opens in management mode)

Gallery opens as full-screen modal overlay.

GALLERY INTERFACE
─────────────────

Header:
  • Title: "Gallery"
  • Close button: X (top-right)

Tabs (2):
  Images:  Images and image folders only
  Sounds:  Sounds and sound folders only

Breadcrumb Navigation:
  "🖼️ Images / maps / cities" (example path)
  
  • Click any segment to jump to that level
  • Root: Shows type icon + name
  • Droppable: Drag items onto breadcrumb to move to that folder

Controls:
  📁 New Folder:  Creates folder in current location
  🔍 Search:      Filters by name (case-insensitive)
  Sort dropdown:  Name A-Z, Name Z-A, Date Newest, Date Oldest

Content Area:
  Grid of gallery items (folders first, then files)
  • Folder items: 📁 icon, name, date, item count
  • Image items: Thumbnail preview (120px height)
  • Sound items: 🎵 icon (no preview)

GALLERY OPERATIONS
──────────────────

Upload Files:
  1. Drag files onto content area (or breadcrumb for specific folder)
  2. System validates file type (images for Images tab, audio for Sounds tab)
  3. Reads file as base64 via FileReader
  4. Generates unique ID (timestamp-based)
  5. Stores in gallery[] array
  6. Auto-saves if enabled
  
  Multiple files: Processes all valid files in batch
  Invalid types: Skipped with console warning

Create Folder:
  1. Click "📁 New Folder"
  2. Enter folder name (no / or \ characters allowed)
  3. Folder created in current location
  4. Appears at top of list

Rename Item:
  Double-click item name → Edit inline → Press Enter or click away
  
    ⚠️  WARNING: no renaming folders.

Move Item:
  Drag file item onto folder or breadcrumb segment
  → Updates item.folder field
  → Item appears in new location
  
  Note: Cannot move folders (only files draggable)

Update Item:
  Click ↻ button
  → Select new file
  → Replace old file

Delete Item:
  Click × button (only shown if deletable)
  
  Files: Can delete if reference count = 0
  Folders: Can delete if empty (no items, no subfolders)

Select Item (Selection Mode):
  When opened from Image/Sound form:
    Click item → URL field auto-fills with "gallery:ID"
    → Gallery closes automatically
    → Form ready to submit

Reference Counting:
  System scans all images and sounds for gallery references
  • Counts: src="gallery:ID"
  • Color: Blue if 0 (deletable), green if >0 (protected)

FOLDER STRUCTURE
────────────────

Paths:
  Root:      "image" or "sound" (type prefix)
  Subfolder: "image/maps"
  Nested:    "image/maps/cities"

Folder objects:
  {
    id: "unique-timestamp",
    type: "folder",
    content: "image",           // parent type
    name: "maps",
    folder: "image/maps",       // full path
    date: "2026-01-15T..."
  }

File objects:
  {
    id: "unique-timestamp",
    type: "image",              // or "sound"
    content: "data:image/png;base64,...",
    name: "world-map.png",
    folder: "image/maps",
    date: "2026-01-15T..."
  }

GALLERY vs DIRECT FILES
───────────────────────

Gallery advantages:
  ✓ Reusable across multiple images/sounds
  ✓ Organized in folders
  ✓ Reference counting (know what's in use)
  ✓ Rename/move without editing each reference
  ✓ Single source of truth

Gallery disadvantages:
  ✗ All stored in JSON (can bloat file size)
  ✗ Large galleries slow down save/load
  ✗ No thumbnail caching (regenerated each time)

Recommendation:
  • Gallery: Frequently reused assets, small-medium files
  • Direct files: Large assets, one-time use, external hosting

TIPS
────
  • Organize early: Create folder structure before uploading
  • Name consistently: Use prefixes like "map-", "icon-", "bgm-"
  • Avoid renaming folders: Breaks hierarchy (known limitation)
  • Performance: Large galleries (>20 items) may slow down
  • File size: Consider external files for large assets

  ⚠️  WARNING: The maximum gallery size is 500MB

════════════════════════════════════════════════════════════════════════════════
9. AUTO-SAVE & DATA MANAGEMENT
════════════════════════════════════════════════════════════════════════════════

Multiple ways to persist your map data:

AUTO-SAVE (Chrome/Edge/Opera only)
───────────────────────────────────

Uses File System Access API to save directly to your file system.

Setup (first time):
  1. Click "💾 Auto" button in Edit Mode
  2. Browser shows file picker dialog
  3. Select existing map-data.json OR create new file
  4. Button turns green (auto-save active)

Subsequent behavior:
  • Every edit triggers automatic save
  • No need to click save manually
  • Button remains green while active
  • Click again to toggle on/off (file handle preserved)

What triggers auto-save:
  ✓ Add/update/delete images
  ✓ Add/update/delete marks
  ✓ Add/update/delete sounds
  ✓ Reorder any items
  ✓ Upload to gallery
  ✓ Create/rename/delete gallery items
  ✓ Upload data file

What doesn't trigger:
  ✗ Navigation (pan/zoom)
  ✗ Typing in form fields (only on submit)
  ✗ Canvas clicks
  ✗ View toggles (mark mode, sound)

Limitations:
  • Chrome/Edge/Opera only (Firefox/Safari not supported)
  • File handle lost on page reload (must reselect)
  • No backup history (always overwrites)
  • No conflict resolution (last write wins)
  • One file handle per tab (no multi-tab sync)

Recommendations:
  • Save to: data/map-data.json (auto-loads on next startup)
  • Backup regularly: Use Download button before major changes
  • One tab only: Avoid editing same map in multiple tabs

MANUAL DOWNLOAD (All browsers)
───────────────────────────────

Click "💾 Download" button:
  → Generates JSON file from current state
  → Triggers browser download dialog
  → Filename: map-data.json
  → Location: Browser's Downloads folder

Use cases:
  • Creating backups
  • Sharing maps with others
  • Versioning (rename to map-v1.json, map-v2.json, etc.)
  • Firefox/Safari workflow (no auto-save)

Format:
  {
    "config": [...],        // Hierarchical images
    "generalMarks": [...],  // Standalone marks
    "sounds": [...],        // Audio zones
    "gallery": [...]        // Asset library
  }

⚠️  WARNING: If gallery data exceeds 500MB, the download will fail.
             Use external file paths (img/, sound/ folders) instead of
             gallery storage for large maps.

MANUAL UPLOAD (All browsers)
─────────────────────────────

Click "📁 Upload" button:
  → Opens file picker
  → Select JSON file
  → Validates structure
  → Disable auto-save if enabled
  → Replaces ALL current data
  → Renders canvas with new data

Validation checks:
  ✓ Valid JSON syntax
  ✓ Contains config, generalMarks, sounds arrays
  ✓ Gallery array (optional, defaults to empty)

⚠️  WARNING: Upload replaces everything. No merge capability.

Use cases:
  • Loading backups
  • Switching between map projects
  • Importing shared maps
  • Restoring after mistakes

AUTO-LOAD ON STARTUP
─────────────────────

Application automatically fetches data/map-data.json on page load:
  • If exists: Loads data
  • If missing: Starts with empty map
  • If malformed: Logs error, starts empty

This enables seamless workflow: Edit → Auto-save → Reload → Continues where left off

DATA FILE SIZE CONSIDERATIONS
──────────────────────────────

JSON can grow very large due to base64 encoding:

  Original image: 5 MB
  Base64 encoded: ~6.7 MB (+33%)
  Multiple images: 10 × 5MB = 67 MB JSON file

Performance impacts:
  • Save time: >50MB may freeze UI for seconds
  • Load time: Large JSON takes longer to parse
  • Download: Browsers may fail >500MB downloads
  • Memory: Large base64 strings consume RAM
  • Auto-save: Automatically blocked when data exceeds 500MB for safety reasons

Solutions:
  ✓ Use external files in img/ and sound/ folders (relative paths)
  ✓ Compress images before uploading
  ✓ Use gallery sparingly for large assets

Recommendation:
  • Prototyping: Base64 OK (portable, self-contained)
  • Production: External files (better performance)

════════════════════════════════════════════════════════════════════════════════
10. CONFIGURATION REFERENCE
════════════════════════════════════════════════════════════════════════════════

JSON STRUCTURE
──────────────

{
  "config": [
    {
      "name": "World Map",
      "src": "img/world.png",
      "x": 0,
      "y": 0,
      "width": 2000,
      "height": 1200,
      "minScale": 0,
      "maxScale": 5,                    // Optional
      "children": [                     // Optional, recursive structure
        {
          "name": "Kingdom",
          "src": "img/kingdom.png",
          "x": 100,                     // Offset from parent center
          "y": -50,
          "width": 800,
          "height": 600,
          "minScale": 5,
          "children": [ ... ]
        }
      ],
      "marks": [                        // Optional, node marks
        {
          "type": "city",
          "name": "Capital",
          "desc": "The king's seat",
          "x": 0,                       // Offset from image center
          "y": 0
        }
      ]
    }
  ],

  "generalMarks": [
    {
      "type": "landmark",               // dot/city/dungeon/fight/treasure/
      "name": "Ancient Ruins",          //   landmark/enemy
      "desc": "Long forgotten...",
      "x": 500,                         // World coordinates
      "y": -300,
      "parentPath": "0,1"               // Optional, link to image parent
    }
  ],

  "sounds": [
    {
      "name": "Forest",
      "src": "sound/forest.mp3",
      "x1": -1000,
      "y1": -500,
      "x2": 1000,
      "y2": 500,
      "minScale": 0,
      "maxScale": 10                    // Optional
    }
  ],

  "gallery": [
    {
      "id": "1234567890",
      "type": "image",                  // or "sound" or "folder"
      "content": "data:image/png;base64,...",
      "name": "world-map.png",
      "folder": "image/maps",
      "date": "2026-01-15T12:00:00.000Z"
    }
  ]
}

COORDINATES SYSTEM
──────────────────

Origin: (0, 0) = center of canvas
Axes:   +X right, -X left, +Y down, -Y up
Units:  Arbitrary (recommend pixels for 1:1 at scale 1.0)

Scale factor: Zooming is exponential (each scroll multiplies scale by 1.1 or 0.9)
              Example: 1.0 → 1.1 → 1.21 → 1.33 → 1.46 (consistent 10% steps)

MARK TYPES
──────────

Available types: dot, city, dungeon, fight, treasure, landmark, enemy

Icons stored in: mark/dot.svg, mark/city.svg, ... mark/enemy.svg

Custom icons: Replace SVG files (maintain 24×24px size)

AUDIO FORMATS
─────────────

Recommended: MP3 (universal browser support)
Supported: OGG, WAV, M4A (browser-dependent)
Volume: Fixed 30% (modify audio file volume if you want different levels)

════════════════════════════════════════════════════════════════════════════════
11. TIPS & BEST PRACTICES
════════════════════════════════════════════════════════════════════════════════

PERFORMANCE
───────────

Images:
  • Compress before uploading (Photoshop, TinyPNG, ImageOptim)
  • Reasonable dimensions (4096×4096 max recommended)
  • Use JPEG for photos, PNG for graphics
  • External files > base64 for large images

Sounds:
  • 64-128kbps MP3 adequate for ambient audio
  • Trim silence from start/end
  • Use mono instead of stereo when possible
  • Create seamless loops (no clicks at loop point)

Gallery:
  • Keep under 40 items for good performance
  • Use folders to organize (improves browsing)
  • Delete unused assets regularly

Hierarchy:
  • Limit nesting depth (<20 levels recommended)
  • Test zoom transitions for smooth experience
  • Avoid overlapping minScale values (causes flicker)

WORKFLOW
────────

Planning:
  • Sketch hierarchy on paper first
  • Define scale ranges before creating images
  • Use consistent coordinate system

Organization:
  • Name everything descriptively
  • Use prefixes: "map-", "icon-", "bgm-", "sfx-"
  • Create folder structure early
  • Document complex setups in separate notes

Editing:
  • Enable auto-save at start of session
  • Test frequently in View Mode
  • Use search to find items quickly
  • Click canvas elements for fast editing

Backup:
  • Download before major changes
  • Use version numbering (map-v1.json, map-v2.json)
  • Keep project files in version control (Git)

SCALE RANGES
────────────

Progressive reveal strategy:

  Base layer:    minScale 0,  maxScale 3
  Level 2:       minScale 3,  maxScale 9
  Level 3:       minScale 9,  maxScale 27
  Detail layer:  minScale 27, maxScale (empty)

Pattern: Each level 3× the previous (smooth progression)

No overlap: Prevents both layers visible simultaneously

SOUND DESIGN
────────────

Ambient layers:
  • Wide area, low minScale: General ambience (forest, ocean)
  • Medium area, mid minScale: Regional sounds (village, cave)
  • Small area, high minScale: Specific sounds (waterfall, fire)

Priority ensures detail sounds override general ambience.

MARKER STRATEGY
───────────────

Node marks: Contextual details
  • Room features in buildings
  • Shop signs in cities
  • Hazards in dungeons

General marks: Major waypoints
  • Quest objectives
  • Fast travel points  
  • Story locations

Enemy marks: Combat tracking
  • Boss encounters
  • Monster lairs
  • Filtered separately for gameplay

COMMON PATTERNS
───────────────

World → Region → Location:
  World map (scale 0-5)
  └─ Continent (scale 5-15)
     └─ Kingdom (scale 15-30)
        └─ City (scale 30-100)
           └─ Building (scale 100+)

Overworld + Dungeons:
  Overworld (scale 0-10, general marks)
  Dungeon A (scale 10-50, node marks)
  Dungeon B (scale 10-50, node marks)
  [Separate hierarchies, no parent link]

Battle map:
  Tactical grid (scale 50-200)
  └─ Character markers (enemy type)
  └─ Terrain features (landmark type)
  └─ Objectives (treasure type)

════════════════════════════════════════════════════════════════════════════════
12. TROUBLESHOOTING
════════════════════════════════════════════════════════════════════════════════

BLANK PAGE / WON'T LOAD
───────────────────────

Symptom: Nothing appears, blank black screen

Causes & Solutions:
  ✗ Opened file:// directly
    → Must use HTTP server (see Quick Start)
  
  ✗ map-data.json malformed
    → Check browser console (F12) for errors
    → Validate JSON syntax (jsonlint.com)
    → Try uploading known-good JSON
  
  ✗ JavaScript errors
    → Open console (F12), check for errors
    → Report to ime.bugreport@gmail.com

IMAGES NOT DISPLAYING
─────────────────────

Symptom: Blank canvas or missing images

Causes & Solutions:
  ✗ Wrong file path
    → Verify file exists at specified path
    → Use relative paths: img/myimage.png
    → Check case sensitivity (image.PNG vs image.png)
  
  ✗ Scale range wrong
    → Check minScale isn't too high for current zoom
    → Try setting minScale to 0 temporarily
    → Verify maxScale > minScale (if set)
  
  ✗ Parent image not visible
    → Child images only show when parent shows
    → Check parent's scale range
  
  ✗ CORS blocked (external URLs)
    → Server must send Access-Control-Allow-Origin header
    → Or use base64 embedding instead
  
  ✗ Gallery reference broken
    → Gallery item was deleted
    → Update URL to new gallery item or direct path

MARKS NOT SHOWING
─────────────────

Symptom: Markers invisible or wrong type showing

Causes & Solutions:
  ✗ Mark visualizer mode wrong
    → Click 📍 button to cycle to "All marks" (🗺️)
    → Mode 0: Only land marks (enemy hidden)
    → Mode 1: Only enemy marks
    → Mode 3: All marks hidden
  
  ✗ Parent image not visible
    → Node marks inherit parent visibility
    → Check parent image scale range
  
  ✗ Position off-screen
    → Mark may be far from current view
    → Check x/y values in management list
    → Use search to find and edit

SOUNDS NOT PLAYING
──────────────────

Symptom: No audio, or wrong audio playing

Causes & Solutions:
  ✗ Sound toggle disabled
    → Click 🔊 button to enable
  
  ✗ Not in zone
    → Viewport CENTER must be inside zone rectangle
    → Zoom in/out to see zone outline (Edit Mode)
  
  ✗ Wrong scale
    → Check minScale and maxScale values
    → Current scale must be in range
  
  ✗ No user interaction yet
    → Browser autoplay policy requires click/touch first
    → Click anywhere on page, then try
  
  ✗ Priority conflict
    → Multiple zones overlap, only first plays
    → Check minScale values (higher = higher priority)
    → Reorder sounds in management list
  
  ✗ Invalid audio file
    → Check file format (MP3 recommended)
    → Test URL directly in browser
    → Check browser console for errors
  
  ✗ Volume too low
    → Fixed at 30%, check system volume
    → Check browser isn't muted

AUTO-SAVE NOT WORKING
─────────────────────

Symptom: Changes don't persist, button stays gray

Causes & Solutions:
  ✗ Wrong browser
    → Use Chrome, Edge, or Opera
    → Firefox/Safari don't support File System Access API
    → Use manual Download/Upload instead
  
  ✗ File deleted/moved
    → File handle became invalid
    → Click Auto button again to reselect file
  
  ✗ Permission denied
    → Grant file access when browser prompts
    → Check file isn't read-only
  
  ✗ File handle lost
    → Page reload loses handle (known limitation)
    → Relink by clicking Auto button

CLICK-TO-EDIT NOT WORKING
──────────────────────────

Symptom: Clicking canvas doesn't load item into form

Causes & Solutions:
  ✗ Not in Edit Mode
    → Click "Edit Mode" button first
  
  ✗ Wrong mode tab
    → Click-to-edit only works in corresponding mode
    → Image clicks → Image tab
    → Mark clicks → Mark tab
    → Sound clicks → Sound tab
  
  ✗ Overlapping elements
    → Multiple items at same location
    → Priority: Marks → Sounds → Images
    → Use management list Edit button instead
  
  ✗ Element not visible
    → Item may be outside scale range
    → Zoom to make it visible first

GALLERY ISSUES
──────────────

Gallery won't open:
  → Check browser console for errors
  → Try closing and reopening Edit Mode

Can't delete gallery item:
  → Item is referenced (refs > 0)
  → Find all uses in image/sound lists
  → Update or delete references first

Items broken after upload:
  → Gallery references point to old IDs
  → Re-upload assets to gallery
  → Update URLs to new gallery references

Folder hierarchy broken:
  → Folder was renamed (changes name but not path)
  → Don't rename folders (known limitation)
  → Delete and recreate with correct name

PERFORMANCE ISSUES
──────────────────

Symptom: Slow, laggy, or freezing

Causes & Solutions:
  ✗ Too many images
    → Limit visible images (<100 at once)
    → Use scale ranges to hide distant layers
  
  ✗ Large image files
    → Compress images before uploading
    → Use external files instead of base64
  
  ✗ Large JSON file
    → Check file size (>50MB causes slowdown)
    → Move assets to img/sound folders
    → Clear unused gallery items
  
  ✗ Deep hierarchy
    → Flatten structure (<20 levels)
    → Split into separate map files
  
  ✗ Browser memory
    → Close other tabs
    → Restart browser
    → Use Chrome (best performance)

DATA CORRUPTION
───────────────

Symptom: Errors after editing JSON manually

Solutions:
  → Validate JSON syntax (jsonlint.com)
  → Check required fields present
  → Verify arrays not objects: config: [] not config: {}
  → No circular references in parent chains
  → Gallery IDs unique (no duplicates)
  → Restore from backup if needed

CONTACT SUPPORT
───────────────

For persistent issues:
  📧 ime.bugreport@gmail.com
  → See 15. CONTACT

Or click 🪲 button in Edit Mode for quick email link.

════════════════════════════════════════════════════════════════════════════════
13. TECHNICAL REFERENCE
════════════════════════════════════════════════════════════════════════════════

BROWSER COMPATIBILITY
─────────────────────

Feature support matrix:

  ┌────────────┬──────────┬──────────┬───────────┬───────────┬─────────┐
  │  Feature   │  Chrome  │   Edge   │  Firefox  │  Safari   │  Opera  │
  ├────────────┼──────────┼──────────┼───────────┼───────────┼─────────┤
  │  View Mode │    ✓     │    ✓    │     ✓     │     ✓     │    ✓   │
  │  Edit Mode │    ✓     │    ✓    │     ✓     │     ✓     │    ✓   │
  │  Gallery   │    ✓     │    ✓    │     ✓     │     ✓     │    ✓   │
  │  Auto-Save │    ✓     │    ✓    │     ✗     │     ✗     │    ✓   │
  │  Touch     │    ✓     │    ✓    │     ✓     │     ✓     │    ✓   │
  │  Audio     │    ✓     │    ✓    │     ✓     │  ✓ (*)    │    ✓   │
  └────────────┴──────────┴──────────┴───────────┴───────────┴─────────┘

  (*) Safari requires user interaction before audio plays (stricter policy)

Minimum versions:
  • Chrome 86+ (for File System Access API)
  • Edge 86+
  • Firefox: Latest (no auto-save)
  • Safari: Latest (no auto-save)
  • Opera 72+

Mobile browsers:
  • Chrome Android: ✓ View/Edit, ✗ Auto-save
  • Safari iOS: ✓ View/Edit, ✗ Auto-save
  • UI not optimized for small screens

TECHNICAL STACK
────────────────

Pure web technologies:
  • HTML5 Canvas API (rendering)
  • CSS3 (styling with custom properties)
  • Vanilla JavaScript ES6+ (no frameworks)

APIs used:
  • Canvas 2D Context (drawing)
  • File System Access API (auto-save, Chrome/Edge only)
  • FileReader API (base64 conversion)
  • Web Audio API (sound playback)
  • Touch Events API (mobile support)
  • Fetch API (loading JSON)

No external dependencies:
  • No jQuery
  • No React/Vue/Angular
  • No build process (Webpack/Vite)
  • Single HTML file (6000+ lines)

ARCHITECTURE
────────────

State management:
  • AppState object holds global state
  • config[], generalMarks[], sounds[], gallery[] arrays
  • Centralized render() function
  • Event-driven updates

Rendering:
  • Canvas cleared and redrawn each frame
  • No dirty region optimization
  • Order: Images → Sounds (zones) → Marks
  • 60 FPS target (requestAnimationFrame)

Data flow:
  Form submission → Validate → Update arrays → Auto-save → Render

Coordinate system:
  • World coordinates: Arbitrary units
  • Screen coordinates: Canvas pixels
  • Transform: scale * (worldPos - origin) + canvasCenter

LIMITATIONS
───────────

Canvas rendering:
  • CPU-based (no GPU acceleration)
  • No DOM elements (pure canvas drawing)
  • Large images (>4096px) may cause issues
  • Very high zoom (>100x) precision loss

Images:
  • No rotation support (axis-aligned only)
  • No skew/perspective transforms
  • Aspect ratio not auto-preserved
  • CORS restrictions on external URLs

Marks:
  • Fixed 24×24px size (doesn't scale with zoom)
  • Limited to 7 types (SVG files)
  • No custom colors per mark
  • Tooltips may overflow screen edges

Sounds:
  • Rectangles only (no circles/polygons)
  • No rotation (axis-aligned)
  • One sound at a time (no layering)
  • Fixed 30% volume (not adjustable)
  • No fade in/out

Gallery:
  • All stored in JSON (bloats file size)
  • No thumbnail caching
  • Reference counting scans all data (may be slow >20 items)
  • Cannot move folders
  • Cannot delete non-empty folders

Auto-save:
  • Chrome/Edge/Opera only (no Firefox/Safari)
  • File handle lost on page reload
  • No backup history (always overwrites)
  • No multi-tab synchronization

UI:
  • English only (no i18n)
  • Dark theme only
  • No keyboard shortcuts
  • Minimal accessibility (screen readers)
  • Not mobile-optimized

Data:
  • Single JSON file (no database)
  • No data compression
  • No incremental loading (parses entire JSON)
  • No undo/redo
  • No collaborative editing

PERFORMANCE CHARACTERISTICS
────────────────────────────

Recommended limits:
  • Images: <200 total, <50 visible at once
  • Marks: <1000 total
  • Sounds: <50 zones
  • Gallery: <40 items
  • JSON size: <400 MB (for reasonable save/load speed)
  • Hierarchy depth: <15 levels

Observed slowdowns:
  • >10MB images: Load lag, render lag
  • >400MB JSON: 3-5 second save, 2-3 second parse
  • >40 gallery items: Gallery UI sluggish
  • >50 visible images: Frame rate drops
  • Deep hierarchy (>15 levels): Stack overflow risk

Optimization tips:
  • Compress images before upload
  • Use external files for large assets
  • Limit gallery size
  • Adjust scale ranges to reduce visible items
  • Close other browser tabs (free memory)

SECURITY CONSIDERATIONS
───────────────────────

Threats:
  • XSS via JSON injection (if loading untrusted JSON)
  • HTML in names not sanitized (gallery items, mark names)
  • CORS restrictions protect against malicious images
  • No authentication/authorization (local-only app)

Best practices:
  • Only load JSON from trusted sources
  • Avoid special characters in names (<, >, &, etc.)
  • Keep project files in secure location
  • No sensitive data in map files (assumed public)

EXTENDING THE APPLICATION
──────────────────────────

Custom mark icons:
  1. Create 24×24px SVG file
  2. Save to mark/ folder as newtype.svg
  3. Add to mark type dropdown in HTML
  4. Add CSS class .mark-newtype with background-image

Custom styling:
  • Edit CSS custom properties (:root section)
  • Modify colors, fonts, spacing
  • Responsive design possible (media queries)

New features:
  • Pure JavaScript (no transpilation needed)
  • Follow existing patterns (AppState, render loop)
  • Add to mode tabs or new sidebar sections
  • Update JSON schema if new data fields

FOLDER STRUCTURE
────────────────

Template/
├── asset/
│   ├── img/
│   │   └── [your images]    [External image files]
│   └── sound/
│       └── [your audio]     [External audio files]
├── data/
│   └── map-data.json        [Your map data, auto-created if missing]
├── mark/
│   ├── dot.svg              [Mark's icons]
│   ├── city.svg
│   ├── dungeon.svg
│   ├── fight.svg
│   ├── treasure.svg
│   ├── landmark.svg
│   ├── enemy.svg
│   └── icon.png             [Website icons]
├── index.html               [6000+ lines, all-in-one application]
├── launcher.bat             [Windows quick-start script]
└── README.txt               [This file]

FILE SIZE EXAMPLES
──────────────────

Typical project:
  • Small (RPG session): 1-5 MB JSON, 10-20 images, few sounds
  • Medium (region map): 10-30 MB JSON, 50-100 images, 10+ sounds
  • Large (full campaign): 50+ MB JSON, 200+ images, 20+ sounds

Base64 overhead:
  • 1 MB image → 1.33 MB base64 (+33%)
  • 5 MB image → 6.67 MB base64 (+33%)
  • 10× 5 MB images → 66.7 MB JSON

External files alternative:
  • JSON: <1 MB (just references)
  • img/ folder: 50 MB (actual images)
  • Total: 51 MB (but JSON loads fast)
  • Needed asset folder for sharing

════════════════════════════════════════════════════════════════════════════════
14. VERSION HISTORY
════════════════════════════════════════════════════════════════════════════════

  v1.4 (January 2026)
  ───────────────────
  • Architecture overhaul with modular ES6+ code
  • Design system implementation with CSS custom properties
  • Enhanced performance and validation

  v1.3 (January 2026)
  ───────────────────
  • Asset management system with gallery interface
  • Folder organization and drag-drop uploads

  v1.2 (December 2025)
  ────────────────────
  • Data persistence with JSON export/import
  • Auto-save functionality for Chrome/Edge

  v1.1 (November 2025)
  ────────────────────
  • Full editing capabilities with sidebar interface
  • Add, edit, and manage map elements

  v1.0 (October 2025)
  ───────────────────
  • Initial release with map visualization
  • Hierarchical zoom and navigation system

════════════════════════════════════════════════════════════════════════════════
15. CONTACT
════════════════════════════════════════════════════════════════════════════════

DEVELOPER
─────────
Francesco Bolner
📧 ime.bugreport@gmail.com

BUG REPORTS
───────────
Click 🪲 button in Edit Mode for pre-filled email, or send to:
📧 ime.bugreport@gmail.com
Subject: "BUG - [title]"

Please include:
  • Detailed description of the issue
  • Steps to reproduce
  • Expected vs actual behavior
  • Browser and OS version
  • Console errors (F12 → Console, if any)
  • Screenshot (if visual issue)
  • Sample JSON (if data-related, optional)
  • Other relevant information

FEATURE REQUESTS
────────────────
📧 ime.bugreport@gmail.com
Subject: "FEATURE - [title]"

GENERAL INQUIRIES
─────────────────
For licensing, collaboration, or other questions:
📧 ime.bugreport@gmail.com
Subject: "SUPPORT - [title]"

⚠️  WARNING: Emails without the correct subject format will not be taken 
             into consideration. Always use "BUG - ", "FEATURE - ", or 
             "SUPPORT - " prefix.

⚠️  Include username for credits

Example Bug Report:
─────────────────
  To: ime.bugreport@gmail.com
  Subject: BUG - Audio do not work
  
  Description:
  When I go in the sound zone the audio do not work.
  
  Steps to reproduce:
  1. Open the browser
  2. Zoom in to the sound zone
  
  Expected vs actual behavior:
  Expected to hear the sound, but no audio plays.
  
  Browser and OS version:
  Windows 11, Chrome
  
  Console errors:
  No
  
  Screenshot:
  No
  
  JSON:
  No

════════════════════════════════════════════════════════════════════════════════
16. LICENSE
════════════════════════════════════════════════════════════════════════════════

Apache License 2.0

Copyright 2025 Francesco Bolner

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

SUMMARY
───────

You are free to:
  ✓ Use commercially
  ✓ Modify
  ✓ Distribute
  ✓ Sublicense
  ✓ Use privately

Under the following terms:
  • Include copyright notice
  • Include license text
  • State changes made
  • Include NOTICE file (if provided)

Limitations:
  ✗ No trademark use
  ✗ No liability
  ✗ No warranty

For full license text, visit: https://www.apache.org/licenses/LICENSE-2.0

═══════════════════════════════════════════════════════════════════════════════

                            🗺️  HAPPY MAPPING!

Create stunning worlds, plan epic campaigns, visualize complex systems.
The only limit is your imagination.

════════════════════════════════════════════════════════════════════════════════

Version: 1.4
Last Updated: January 15, 2026

════════════════════════════════════════════════════════════════════════════════
