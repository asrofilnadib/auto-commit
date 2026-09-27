# Push ke GitHub (asrofilnadib)

Repo lokal sudah **history baru** (1 commit), tanpa ribuan commit dari template.

## 1. Login GitHub CLI (sekali)

```bash
export PATH="$HOME/.local/bin:$PATH"
gh auth login
```

Pilih: GitHub.com → SSH atau HTTPS → login browser.

## 2. Buat repo & push (fresh)

```bash
cd ~/Project/personal/auto-commit

gh repo create asrofilnadib/auto-commit --public --source=. --remote=origin --push --description "Auto commit via GitHub Actions"
```

Kalau repo **sudah ada** dan mau timpa history lama:

```bash
cd ~/Project/personal/auto-commit
git remote add origin git@github.com:asrofilnadib/auto-commit.git 2>/dev/null || git remote set-url origin git@github.com:asrofilnadib/auto-commit.git
git push -u origin main --force
```

## 3. Aktifkan permission Actions (wajib)

Di browser: **https://github.com/asrofilnadib/auto-commit/settings/actions**

- **Workflow permissions** → **Read and write permissions**
- Save

## 4. Tes workflow

**Actions** → **Auto commit** → **Run workflow** → branch `main`

Atau tunggu cron (menit 28 tiap jam).

## 5. SSH key (kalau `Permission denied (publickey)`)

```bash
cat ~/.ssh/id_ed25519.pub
```

Tambahkan di: https://github.com/settings/keys
