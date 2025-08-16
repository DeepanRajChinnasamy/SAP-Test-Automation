import os
import glob
import win32com.client as win32


def send_latest_excel_via_outlook(folder_path, recipients, subject, body):
    """
    Finds the latest Excel file in a folder and sends it via Outlook.

    Args:
        folder_path (str): Folder to search for Excel files.
        recipients (str): Semicolon-separated email addresses.
        subject (str): Email subject.
        body (str): Email body text.
    """
    # Find all .xls and .xlsx files
    files = glob.glob(os.path.join(folder_path, "*.xlsx")) + glob.glob(os.path.join(folder_path, "*.xls"))

    if not files:
        raise FileNotFoundError(f"No Excel files found in folder: {folder_path}")

    # Find the latest file by modification time
    latest_file = max(files, key=os.path.getmtime)
    print(f"Latest Excel file: {latest_file}")

    # Connect to Outlook
    outlook = win32.Dispatch('Outlook.Application')
    mail = outlook.CreateItem(0)  # 0 = olMailItem

    mail.To = recipients
    mail.Subject = subject
    mail.Body = body
    mail.Attachments.Add(latest_file)

    # Send the email
    mail.Send()
    print(f"Email sent with attachment: {latest_file}")
    return latest_file


# Example usage
if __name__ == "__main__":
    send_latest_excel_via_outlook(
        folder_path=r"C:\Users\YourUser\Downloads",
        recipients="teammate1@company.com; teammate2@company.com",
        subject="Latest Excel Report",
        body="Hello team,\n\nPlease find the latest report attached.\n\nBest regards"
    )




