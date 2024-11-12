from PyPDF2 import PdfReader

def readpdf(pdf_path):
    try:
        # Creating a pdf reader object
        reader = PdfReader(pdf_path)

        # Printing the number of pages in the pdf file
        num_pages = len(reader.pages)
        print(f"Number of pages in the PDF: {num_pages}")

        # Extracting text from each page
        for page_number, page in enumerate(reader.pages):
            text = page.extract_text()
            print(f"\nPage {page_number + 1}:\n{text}")
        return text

    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    pdf_path = input('Enter the path to the PDF file: ')
    # file_path= input('Enter the path to the PDF file: ')
    readpdf(pdf_path)



