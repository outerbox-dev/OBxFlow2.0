# OuterBox Branding Guide for N8N

**OBxFlow2.0 - Custom Theme Implementation**

---

## 🎨 Brand Overview

This directory contains all OuterBox brand assets for customizing the N8N interface to match our company identity as defined in **OuterBox Brand Standards 2025**.

---

## 📊 Brand Colors

### Primary Colors

```css
--obx-dark-blue: #17212E;      /* Dark Blue - Primary backgrounds, text */
--obx-blue: #1D4E89;            /* OBx Blue - Primary brand color */
--obx-orange: #C75300;          /* Orange - Accent, CTAs */
--obx-gold: #FFB703;            /* Gold - Highlights, accents */
```

### Background Colors

```css
--obx-frost: #EEF3F6;           /* Frost - Light backgrounds */
--obx-white: #FFFFFF;           /* White - Backgrounds */
--obx-deep-blue: #033F63;       /* Deep Blue - Dark backgrounds */
--obx-grey: #747D85;            /* Grey - Alternative backgrounds */
--obx-slate: #5C6C80;           /* Slate - Text on light backgrounds */
```

### Accent Colors

```css
--obx-sunset: #F29112;          /* Sunset - Bridge between orange/gold */
--obx-bright-blue: #0066DC;     /* Bright Blue - Links, buttons */
```

---

## 🔤 Typography

### Primary Font: Roboto

**Font Weights:**
- **Roboto Black** - Large headings (22px+)
- **Roboto Bold** - Headings (14-18px)
- **Roboto Medium** - UI elements, buttons
- **Roboto Regular** - Body text (10px)

**Font Sizing:**
- Title/H1: 22px (Black/Bold)
- H2: 18px (Black/Bold)
- H3: 14px (Bold)
- H4: 12px (Bold)
- Subtitle: 12px (Regular), Orange
- Body: 10px (Regular)
- Small: 9px (Regular)

**Line Spacing:** 1.15 for readability

---

## 🏷️ Logo Usage

### Logo Specifications

**Primary Logo:** OBx wordmark (lowercase 'x')  
**File Formats:** SVG (preferred), PNG  
**Versions Needed:**
- Dark Blue logo on white background (primary)
- White logo on dark backgrounds
- Vertical logo (limited use)

### Logo Files

Place logo files in `logos/` directory:

```
logos/
├── logo-dark.svg           # Dark blue logo for light backgrounds
├── logo-white.svg          # White logo for dark backgrounds
├── logo-vertical-dark.svg  # Vertical version (if needed)
├── logo-vertical-white.svg
└── favicon.ico             # Favicon for browser tabs
```

### Logo Rules

✅ **DO:**
- Use dark blue logo on white/light backgrounds
- Use white logo on dark/brand color backgrounds
- Maintain adequate spacing around logo
- Use SVG format when possible

❌ **DON'T:**
- Modify logo proportions or colors
- Use logo over busy images without background
- Make logo smaller than 120px width
- Add effects or filters to logo

---

## 🎭 Custom CSS Theme

### Theme File Structure

```
css/
├── outerbox-theme.css       # Main theme file
├── components.css           # Component-specific styles
└── variables.css            # CSS custom properties
```

### CSS Variables

Create `css/variables.css`:

```css
:root {
  /* Primary Colors */
  --color-primary: #1D4E89;
  --color-primary-dark: #17212E;
  --color-accent: #C75300;
  --color-accent-light: #FFB703;
  
  /* Backgrounds */
  --color-background: #FFFFFF;
  --color-background-light: #EEF3F6;
  --color-background-dark: #17212E;
  
  /* Text */
  --color-text: #17212E;
  --color-text-light: #5C6C80;
  --color-text-inverse: #FFFFFF;
  
  /* UI Elements */
  --color-link: #0066DC;
  --color-success: #4AA17B;
  --color-warning: #F29112;
  --color-error: #D95F55;
  
  /* Typography */
  --font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-size-base: 10px;
  --font-size-h1: 22px;
  --font-size-h2: 18px;
  --font-size-h3: 14px;
  --line-height: 1.15;
  
  /* Spacing */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  
  /* Borders */
  --border-radius: 4px;
  --border-color: #EEF3F6;
  
  /* Shadows */
  --shadow-sm: 0 2px 4px rgba(23, 33, 46, 0.1);
  --shadow-md: 0 4px 8px rgba(23, 33, 46, 0.15);
  --shadow-lg: 0 8px 16px rgba(23, 33, 46, 0.2);
}
```

### Main Theme File

Create `css/outerbox-theme.css`:

```css
/* Import variables */
@import 'variables.css';

/* Import Roboto font */
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap');

/* Global Styles */
body {
  font-family: var(--font-family);
  font-size: var(--font-size-base);
  line-height: var(--line-height);
  color: var(--color-text);
  background-color: var(--color-background);
}

/* Headings */
h1, h2, h3, h4, h5, h6 {
  font-family: var(--font-family);
  font-weight: 700;
  color: var(--color-primary-dark);
}

h1 { font-size: var(--font-size-h1); font-weight: 900; }
h2 { font-size: var(--font-size-h2); font-weight: 900; }
h3 { font-size: var(--font-size-h3); font-weight: 700; }

/* Links */
a {
  color: var(--color-link);
  text-decoration: none;
  transition: opacity 0.2s;
}

a:hover {
  opacity: 0.8;
}

/* Buttons */
.button-primary {
  background-color: var(--color-primary);
  color: var(--color-text-inverse);
  border: none;
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius);
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.button-primary:hover {
  background-color: var(--color-primary-dark);
}

.button-accent {
  background-color: var(--color-accent);
  color: var(--color-text-inverse);
}

/* Cards */
.card {
  background: var(--color-background);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  padding: var(--spacing-md);
  box-shadow: var(--shadow-sm);
}

/* Navigation */
.nav-header {
  background-color: var(--color-primary-dark);
  color: var(--color-text-inverse);
  padding: var(--spacing-md);
}

/* Workflow Canvas */
.workflow-canvas {
  background-color: var(--color-background-light);
}

/* Node Colors */
.node-trigger { border-color: var(--color-accent); }
.node-action { border-color: var(--color-primary); }
.node-success { border-color: var(--color-success); }
.node-error { border-color: var(--color-error); }
```

---

## 🖼️ Image Assets

### Required Images

```
images/
├── login-background.jpg    # Login page background
├── dashboard-hero.jpg      # Dashboard hero image
├── pattern-subtle.png      # Subtle background pattern
└── sprite-elements/        # Decorative squares
    ├── blue-square.svg
    ├── orange-square.svg
    └── gold-square.svg
```

### Image Guidelines

**Login Background:**
- Size: 1920x1080px minimum
- Format: JPG (optimized)
- Style: Professional, OuterBox office or team photo
- Overlay: Dark blue gradient for text readability

**Dashboard Images:**
- Professional photography
- OuterBox brand colors featured
- Team collaboration themes
- High quality (300dpi for print, 72dpi for web)

---

## 🔧 Implementation Steps

### Step 1: Prepare Assets

1. Collect all brand assets:
   - Logos (SVG format)
   - Brand colors defined
   - Roboto font files (or use Google Fonts CDN)
   - Images optimized

2. Organize in directory structure:
   ```
   custom/branding/
   ├── logos/
   ├── css/
   └── images/
   ```

### Step 2: Create CSS Theme

1. Create `css/variables.css` with brand colors
2. Create `css/outerbox-theme.css` with custom styles
3. Create `css/components.css` for specific components

### Step 3: Configure N8N

Add to `.env`:
```bash
N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom
```

### Step 4: Mount Volumes

Ensure `docker-compose.yml` has:
```yaml
volumes:
  - ./custom:/home/node/.n8n/custom
```

### Step 5: Apply Theme

1. Restart N8N: `docker-compose restart n8n`
2. Clear browser cache
3. Test all pages and components
4. Adjust as needed

---

## 🎨 Customization Areas

### Priority 1 - High Visibility

- [ ] Login page background and logo
- [ ] Top navigation bar
- [ ] Workflow canvas background
- [ ] Primary buttons and CTAs
- [ ] Brand colors throughout

### Priority 2 - User Interface

- [ ] Node styling
- [ ] Sidebar menus
- [ ] Form elements
- [ ] Modal dialogs
- [ ] Tooltips and notifications

### Priority 3 - Details

- [ ] Icons and badges
- [ ] Loading animations
- [ ] Error messages
- [ ] Empty states
- [ ] Footer branding

---

## 📝 Brand Compliance Checklist

- [ ] All brand colors match OBx standards
- [ ] Roboto font used throughout
- [ ] Logo properly sized and positioned
- [ ] Adequate spacing (not cramped)
- [ ] Text readable on all backgrounds
- [ ] CTAs use accent colors (orange/gold)
- [ ] Dark blue for primary actions
- [ ] Consistent with OuterBox web properties
- [ ] Professional appearance maintained
- [ ] No unauthorized color variations

---

## 🔍 Testing Checklist

After implementing branding:

- [ ] Login page displays correctly
- [ ] Logo visible in navigation
- [ ] Colors match brand standards
- [ ] Fonts render properly
- [ ] Buttons styled consistently
- [ ] Workflow canvas looks professional
- [ ] No visual bugs or glitches
- [ ] Mobile responsive (if applicable)
- [ ] Cross-browser compatibility
- [ ] Dark mode (if implemented)

---

## 📚 Resources

- [OuterBox Brand Standards 2025](../../BrandStandards__OBx_2025.pdf)
- [N8N Theming Documentation](https://docs.n8n.io/)
- [CSS Custom Properties Guide](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)
- [Roboto Font on Google Fonts](https://fonts.google.com/specimen/Roboto)

---

## 🆘 Support

For branding questions:
- Marketing team: branding@outerbox.com
- Technical issues: devops@outerbox.com
- Brand standards: See project docs

---

**Version:** 1.0  
**Last Updated:** November 15, 2025  
**Maintained By:** OuterBox Marketing & DevOps
