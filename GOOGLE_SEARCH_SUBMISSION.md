# Google Search Submission Checklist - ವಚನ ಸಂಚಯ

## ✅ Technical SEO (Already Implemented)

### 1. Meta Tags (Dynamic)
- ✅ Title tags (unique per page)
- ✅ Meta descriptions (unique per page)
- ✅ Meta keywords (relevant per page)
- ✅ Canonical URLs (self-referencing)
- ✅ Favicon (/favicon.ico)

### 2. Structured Data (JSON-LD)
- ✅ WebSite schema with SearchAction (Sitelinks Searchbox)
- ✅ BreadcrumbList schema on every page
- ✅ Proper @context and @type declarations

### 3. Open Graph & Social
- ✅ og:title, og:description, og:url, og:site_name, og:locale, og:type
- ✅ Twitter Card: twitter:card, twitter:title, twitter:description, twitter:site

### 4. Internationalization
- ✅ Hreflang tags for Kannada (kn) and English (en)
- ✅ x-default hreflang pointing to Kannada version
- ✅ Dynamic HTML lang attribute (kn/en)

### 5. Crawler Accessibility
- ✅ robots.txt (Allow all, Sitemap reference)
- ✅ sitemap-index.xml (237,410 URLs across 5 sitemap files with changefreq/priority)
- ✅ No noindex or nofollow tags anywhere
- ✅ No robots meta blocking crawlers

### 6. Semantic HTML
- ✅ H1 tags on every public page
- ✅ Breadcrumb navigation (visible + structured data)
- ✅ Alt text on logo image
- ✅ Proper heading hierarchy

### 7. Analytics
- ✅ Google Analytics 4 (gtag.js) - G-VME3PFV3ZW
- ✅ Google Search Console verification ready (see below)

---

## 🔧 Manual Steps Required (You Must Do These)

### Step 1: Google Search Console Verification

**Option A: Meta Tag (Recommended)**
1. Go to https://search.google.com/search-console
2. Click "Add Property" → Enter: `https://vachana.sanchaya.net`
3. Choose "URL prefix" method
4. Copy the verification meta tag (looks like: `<meta name="google-site-verification" content="ABC123...">`)
5. Edit `app/views/layouts/application.html.erb`
6. Replace line 14:
   ```
   <meta name="google-site-verification" content="YOUR_VERIFICATION_CODE_HERE" />
   ```
   with your actual code (uncomment the line)
7. Deploy to production
8. Click "Verify" in Search Console

**Option B: HTML File**
1. If you choose HTML file verification in Search Console
2. Create a file named `googleXXXX.html` (replace XXXX with your code) in `public/` folder
3. Deploy to production
4. Verify in Search Console

### Step 2: Submit Sitemap

1. After verification, go to Google Search Console
2. Navigate to: **Sitemaps** (left sidebar)
3. Enter: **`sitemap-index.xml`** (the multi-file sitemap index)
4. Click **Submit**
5. Wait for Google to process (usually within hours)

Note: To regenerate sitemaps, run `ruby scripts/generate_sitemap.rb` from the
application root. This creates 5 sitemap files (50K URLs each) + an index file
in `public/`. Re-submit `sitemap-index.xml` to Google Search Console after
regeneration.

### Step 3: Request Indexing for Key Pages

1. In Search Console, go to **URL Inspection**
2. Test these URLs individually:
   - `https://vachana.sanchaya.net/`
   - `https://vachana.sanchaya.net/vachanakaaras`
   - `https://vachana.sanchaya.net/vachanas/vachana_concord`
   - `https://vachana.sanchaya.net/researches`
   - `https://vachana.sanchaya.net/glossaries`
3. Click **Request Indexing** for each

### Step 4: Production Asset Precompilation

If running in production, precompile assets:
```bash
RAILS_ENV=production bundle exec rake assets:precompile
```

---

## 📋 Additional Recommendations

### 1. Performance Check
- Test page speed: https://pagespeed.web.dev/
- Target: Core Web Vitals (LCP < 2.5s, FID < 100ms, CLS < 0.1)

### 2. Mobile-Friendliness
- Test: https://search.google.com/test/mobile-friendly
- Ensure responsive design works on all devices

### 3. HTTPS Security
- Ensure SSL certificate is valid
- All internal links should use https://

### 4. Content Quality
- Ensure no duplicate content
- Keep vachana content unique and valuable
- Regular updates (daily vachana helps!)

### 5. Monitor Search Console
- Check **Coverage** report for indexing errors
- Check **Performance** report for search queries
- Check **Enhancements** for structured data errors
- Fix any crawl errors promptly

### 6. External Links
- Build backlinks from Kannada literary sites
- Submit to Kannada web directories
- Share on social media (Facebook, Twitter)

---

## 🔍 Verification Commands

Test these locally before deployment:

```bash
# Check robots.txt
curl https://vachana.sanchaya.net/robots.txt

# Check sitemap.xml
curl https://vachana.sanchaya.net/sitemap.xml

# Check meta tags on homepage
curl https://vachana.sanchaya.net/ | grep -i "meta\|title\|canonical"

# Check structured data
curl https://vachana.sanchaya.net/ | grep -A 5 "application/ld+json"
```

---

## ✅ Ready for Submission

Once you complete Step 1 (verification), the site is fully ready for Google Search submission.

**Estimated time to appear in search results: 1-7 days**
**Estimated time to rank for brand terms: 1-2 weeks**
**Estimated time to rank for competitive terms: 3-6 months**

---

## 📞 Support

If you encounter issues:
1. Check Google Search Console **Coverage** report
2. Use Google Rich Results Test: https://search.google.com/test/rich-results
3. Use Google Mobile-Friendly Test: https://search.google.com/test/mobile-friendly
4. Check server logs for 404 errors

---

**Prepared for:** ವಚನ ಸಂಚಯ (vachana.sanchaya.net)
**Date:** 2026-06-13
**Status:** ✅ Ready for Google Search Console submission
