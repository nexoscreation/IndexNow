## ❓ **Troubleshooting**  

🔴 **Bulk Submission Failed (Invalid URLs)**  
- Ensure URLs match the **verified domain** in **IndexNow API**.  
- Double-check that `HOST` in `settings.env` matches your website’s domain.  

🔴 **403 Forbidden (Invalid Key)**  
- Ensure `API_KEY` is **correct** and **matches** the one in your `KEY_LOCATION` file.  
- Check that the `.txt` file is publicly accessible (test it in a browser).  

🔴 **Rate Limit Errors (429 Too Many Requests)**  
- IndexNow limits submissions. Wait & retry later.  
- Avoid submitting **the same URLs multiple times** in a short period.  

---

## 📝 **Log Files**  
- **Success Log**: `./logs/indexnow.log`  
- **Failed URLs Log**: `./logs/failed_urls.log`  

---

1️⃣ **Verify API Key File**  
   - Open: `https://www.yourdomain.com/your-api-key.txt`  
   - The key inside should match `API_KEY` in `settings.env`.  

2️⃣ **Update `settings.env` with the Correct Host**  
   ```bash
   HOST="https://www.yourdomain.com"
   ```

3️⃣ **Reload Configuration & Retry**  
   ```bash
   source ./config/settings.env
   bash scripts/indexnow.sh -s "https://www.yourdomain.com/sitemap.xml"
   ```