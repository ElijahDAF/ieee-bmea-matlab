# MATLAB Workshop — Setup Instructions

Follow these steps to get the two workshop scripts into **MATLAB Online**.

## Step 1 — Download the ZIP

1. Click the green **Code** button.
2. Click **Download ZIP**. The ZIP file will download to your computer.

## Step 2 — Extract the files locally

1. Open your computer's **Downloads** folder and locate the ZIP file.
2. **Windows:** Right-click it and select **Extract All**. **Mac:** Double-click it to extract.
3. Open the extracted folder to see the workshop files.

## Step 3 — Select only the two programming files

Find and select **both** of these MATLAB scripts:

- `generate_ecg.m`
- `workshop_solution.m`

**Windows:** Hold **Ctrl** while clicking both files. **Mac:** Hold **Command** while clicking both files.

Do **not** select the README or upload the whole folder. Files ending in `.m` contain MATLAB code.

## Step 4 — Copy the files into MATLAB Online

1. Visit [MATLAB Online](https://matlab.mathworks.com/) and sign in.
2. Open MATLAB Online and find the **Files** panel on the left (sometimes called **Current Folder**).
3. With the two `.m` files selected on your computer, **drag and drop them into the Files panel**.
4. Alternatively, you can try **Copy** on your computer and **Paste** into the Files panel if your browser supports it. If that doesnt work, use MATLAB Online's **Upload** button and select the two files.
5. Confirm that **both `.m` files appear** in the Files panel.

## Step 5 — Run the scripts

1. Double-click `generate_ecg.m` in MATLAB Online's Files panel to open it in the Editor.
2. Click **Run**. This generates two data files: `ecg_data.mat` and `ecg_noisy.mat`.
3. Confirm the new `.mat` files appear in the Files panel.
4. Open `workshop_solution.m` and click **Run**. Look at the plots and output in the Command Window.

**You're ready for the workshop!** Keep MATLAB Online open.

### Troubleshooting

- **The scripts aren't visible:** Check that you uploaded the two `.m` files to MATLAB Online, not just downloaded them locally.
- **MATLAB says it can't find `ecg_data.mat`:** Run `generate_ecg.m` first. Keep the generated `.mat` files in the same MATLAB folder as `workshop_solution.m`.
- **Drag and drop doesn't work:** Use the **Upload** button in the MATLAB Online Files panel.
