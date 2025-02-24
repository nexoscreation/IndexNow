## ❓ **Troubleshooting**  

### **🚨 Bulk Submission Fails with "Invalid URLs" Error**  
📌 **Solution**: Ensure that your API key is registered for the same domain as your URLs.  

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



## 📝 **Log Files**  
- **Success Log**: `./logs/indexnow.log`  
- **Failed URLs Log**: `./logs/failed_urls.log`  