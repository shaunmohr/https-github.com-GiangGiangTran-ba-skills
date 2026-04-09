# Installing claude-mem on Windows 11 Pro — Beginner's Guide

**What is claude-mem?**
claude-mem is a plugin for Claude Code that gives it persistent memory. It automatically remembers what you worked on in previous sessions and brings that context back when you start a new one — so Claude doesn't "forget" your project between conversations.

---

## Step 1 — Install Git for Windows

Git is the tool that lets you clone (download) code repositories from GitHub.

1. Open your browser and go to: **https://git-scm.com/download/win**
2. The download should start automatically. If not, click **"Click here to download"**.
3. Run the downloaded `.exe` installer.
4. Click **Next** through all the steps — the defaults are fine for beginners.
5. On the screen that says **"Adjusting your PATH environment"**, make sure **"Git from the command line and also from 3rd-party software"** is selected (it usually is by default).
6. Continue clicking **Next** until the install finishes, then click **Finish**.

**Verify Git installed correctly:**
1. Press `Windows + R`, type `cmd`, and press Enter to open Command Prompt.
2. Type the following and press Enter:
   ```
   git --version
   ```
3. You should see something like `git version 2.x.x`. If you do, Git is installed.

---

## Step 2 — Install Node.js (version 18 or newer)

claude-mem requires Node.js to run.

1. Open your browser and go to: **https://nodejs.org**
2. Click the **"LTS"** download button (LTS = Long Term Support — the stable version).
3. Run the downloaded `.msi` installer.
4. Click **Next** through all the steps — the defaults are fine.
5. When asked about **"Tools for Native Modules"**, you can leave the checkbox unchecked unless you know you need it.
6. Click **Install**, then **Finish** when done.
7. **Important:** Close any open Command Prompt windows after installing Node.js.

**Verify Node.js installed correctly:**
1. Open a **new** Command Prompt window (`Windows + R`, type `cmd`, press Enter).
2. Type the following and press Enter:
   ```
   node --version
   ```
3. You should see something like `v20.x.x` or higher. Also check npm:
   ```
   npm --version
   ```
4. Both commands should print a version number. If you see an error, restart your computer and try again.

---

## Step 3 — Install Claude Code

claude-mem is a plugin for Claude Code, so you need Claude Code installed first.

1. Open Command Prompt.
2. Run:
   ```
   npm install -g @anthropic-ai/claude-code
   ```
3. Wait for the install to finish.
4. Verify it installed:
   ```
   claude --version
   ```

> **Note:** If you get a permissions error, right-click Command Prompt in the Start menu and choose **"Run as administrator"**, then try the command again.

---

## Step 4 — Clone the claude-mem Repository

Cloning downloads a copy of the plugin's code to your computer.

1. Decide where you want to store the files. A good place is your Documents folder. In Command Prompt, navigate there:
   ```
   cd %USERPROFILE%\Documents
   ```
2. Clone the repository:
   ```
   git clone https://github.com/thedotmack/claude-mem.git
   ```
3. This creates a new folder called `claude-mem` inside your Documents folder. Move into it:
   ```
   cd claude-mem
   ```
4. Confirm you are inside the folder — you should see the folder name in your prompt, e.g. `C:\Users\YourName\Documents\claude-mem>`.

---

## Step 5 — Install claude-mem

Install the plugin globally using npm, then run the installer. On Windows, this two-step approach is more reliable than using `npx` directly:

```
npm install -g claude-mem
claude-mem install
```

> **Why two commands?** On Windows, `npx claude-mem install` sometimes fails with a "not recognized" error because Windows cannot find the executable that npx downloads. Installing globally with `npm install -g` first ensures Windows registers the command properly.

This command will:
- Automatically download and install any additional dependencies (Bun, uv) if they are missing
- Register the plugin hooks with Claude Code
- Create a settings file at `C:\Users\YourName\.claude-mem\settings.json`

> **Tip:** If you are asked "Do you want to allow this?" or see a Windows Firewall popup during install, click **Allow** — the plugin runs a small local web service on port 37777 that only your computer can access.

**If `claude-mem install` still fails**, open a new Command Prompt window and try again — sometimes the PATH needs a fresh terminal to update after a global install.

---

## Step 6 — Restart Claude Code

After installation, you **must restart Claude Code** for the plugin to take effect.

- If Claude Code is open, close it completely and reopen it.
- Memory from future sessions will now be automatically captured and made available in new sessions.

---

## Step 7 — Verify the Installation

1. Open Claude Code and start a new conversation.
2. Ask Claude something like:
   ```
   Can you search your memory for anything about this project?
   ```
3. On first use there won't be any memories yet — that's normal. After your first session ends, claude-mem will save context and it will be available next time.

You can also open the local web UI in your browser at:
```
http://localhost:37777
```
This shows a dashboard of everything claude-mem has stored.

---

## Troubleshooting

### "'claude-mem' is not recognized as an internal or external command"
This is the most common Windows issue. `npx claude-mem install` downloads the package but Windows cannot find the executable.

**Fix:**
1. Install globally first:
   ```
   npm install -g claude-mem
   ```
2. Open a **new** Command Prompt window (important — the old one won't have the updated PATH).
3. Run:
   ```
   claude-mem install
   ```

### "npx is not recognized" or "npm is not recognized"
Node.js did not install correctly or your PATH was not updated.
- Close all Command Prompt windows and open a new one.
- If still broken, restart your computer.
- If still broken, reinstall Node.js from nodejs.org and check the box that says **"Add to PATH"** during install.

### "git is not recognized"
Git did not install correctly or PATH was not updated.
- Close all Command Prompt windows and open a new one.
- If still broken, restart your computer and try again.

### "Permission denied" or access errors
Run Command Prompt as Administrator:
1. Click the Start button.
2. Type `cmd`.
3. Right-click **Command Prompt** and choose **Run as administrator**.
4. Re-run the failed command.

### Windows Defender or antivirus blocks the install
claude-mem installs Bun (a JavaScript runtime) and uv (a Python package manager) automatically. Some antivirus software may flag these downloads.
- Temporarily disable real-time protection, run the install, then re-enable protection.
- Alternatively, add the `%USERPROFILE%\.claude-mem` folder to your antivirus exclusions.

### Port 37777 is already in use
Another application is using that port. You can change the port in the settings file:
1. Open `C:\Users\YourName\.claude-mem\settings.json` in Notepad.
2. Change the port number to something unused, e.g. `37778`.
3. Save the file and restart Claude Code.

### claude-mem doesn't seem to remember anything
- Make sure you completed a full session (started Claude Code, did some work, then closed it). Memory is saved at session end.
- Check the web UI at `http://localhost:37777` to confirm the worker service is running.

---

## Keeping claude-mem Updated

To get the latest version of claude-mem, open Command Prompt, navigate to the folder you cloned, and run:

```
cd %USERPROFILE%\Documents\claude-mem
git pull
npx claude-mem install
```

Then restart Claude Code.

---

## Uninstalling claude-mem

To remove claude-mem from Claude Code, open Command Prompt and run:

```
npx claude-mem uninstall
```

Then delete the cloned folder:

```
rmdir /s /q %USERPROFILE%\Documents\claude-mem
```

And optionally delete its data:

```
rmdir /s /q %USERPROFILE%\.claude-mem
```

---

## Summary Checklist

- [ ] Git installed and `git --version` works
- [ ] Node.js 18+ installed and `node --version` works
- [ ] Claude Code installed and `claude --version` works
- [ ] Repository cloned with `git clone`
- [ ] Plugin installed with `npx claude-mem install`
- [ ] Claude Code restarted
- [ ] Web UI accessible at `http://localhost:37777`
