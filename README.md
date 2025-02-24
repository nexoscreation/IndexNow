![GitHub Release](https://img.shields.io/github/v/release/nexoscreation/IndexNow.svg?style=flat-square&color=cyan)
![GitHub License](https://img.shields.io/github/license/nexoscreation/IndexNow.svg?style=flat-square&color=cyan)
![GitHub Code](https://img.shields.io/github/languages/code-size/nexoscreation/IndexNow.svg?style=flat-square&color=cyan)

---

# 🚀 IndexNow URL Submit

![Project Banner](image-url)

> A simple **Bash script** to automatically submit URLs to search engines like **Microsoft Bing, Naver, Yandex, Yahoo, and Seznam** using **IndexNow API**.

---

## ✨ Features

✔️ **Single URL Submission**  
✔️ **Bulk URL Submission from a File**  
✔️ **Fetching & Submitting URLs from Sitemaps**  
✔️ **Fetching & Submitting URLs from Web Pages**  
✔️ **Multiple Search Engine Support**

---

## 📥 Installation

### 🔧 Prerequisites

1. **A valid IndexNow API Key**
   - Generate here: [IndexNow Key](https://www.indexnow.org)
2. **API Key Verification File**
   - Create a text file: `your-api-key.txt` (replace with your actual key).
   - Upload it to your website’s root directory:
     ```
     https://www.yourdomain.com/your-api-key.txt
     ```
   - The file must contain the **exact API key**.
3. **Required Tools**
   - **cURL** (Check installation: `curl --version`)
   - Install it if missing:
     ```bash
     sudo apt install curl  # Ubuntu/Debian
     brew install curl      # macOS (Homebrew)
     ```

### ⚡ Installation Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/nexoscreation/IndexNow.git
   cd IndexNow
   ```

2. **Set Up Configuration**

   Edit `config/settings.env` and update the following:

   ```bash
   HOST="https://www.yourdomain.com"
   API_KEY="your-api-key-here"
   KEY_LOCATION="https://www.yourdomain.com/your-api-key.txt"
   ```

---

## 🎯 Usage

### ✅ **Submit a Single URL**

```bash
bash scripts/indexnow.sh -u "https://www.yourdomain.com/sample-page"
```

### ✅ **Submit Bulk URLs from a File**

```bash
bash scripts/indexnow.sh -f urls.txt
```

📌 Ensure `urls.txt` contains **one URL per line**.

### ✅ **Submit URLs from a Sitemap**

```bash
bash scripts/indexnow.sh -s "https://www.yourdomain.com/sitemap.xml"
```

### ✅ **Submit URLs Found on a Web Page**

```bash
bash scripts/indexnow.sh -p "https://www.yourdomain.com"
```

---

## 🤝 Contributing

We ❤️ contributions! Follow these steps to contribute:

1. 🍴 **Fork** the repository
2. 🌿 **Create** a new branch (`git checkout -b feature/AmazingFeature`)
3. 💾 **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. 🚀 **Push** to the branch (`git push origin feature/AmazingFeature`)
5. 🔃 **Open a Pull Request**

📖 _See our [Contribution Guidelines](CONTRIBUTING.md) for more details._

---

## 📄 License

This project is licensed under the **Apache-2.0 license**. See the [LICENSE](LICENSE) file for details.

---

## 📬 Contact & Community

💬 Join us on **Discord**: [Click Here](https://discord.gg/H7pVc9aUK2)  
🐦 **Follow on Twitter**: [@nexoscreation](https://twitter.com/nexoscreator)  
📧 **Email**: [contact@nexoscreation.tech](mailto:contact@nexoscreation.tech)

<p align="center">
  Made with ❤️ by <a href="https://github.com/nexoscreation">@nexoscreation</a>
</p>
