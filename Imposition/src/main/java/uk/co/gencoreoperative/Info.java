package uk.co.gencoreoperative;

import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfDocumentInfo;
import com.itextpdf.kernel.pdf.PdfPage;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.PdfWriter;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Arrays;
import java.util.Optional;

/**
 * Outputs information about the PDF to the command line, useful for diagnostics.
 * <p>
 * Mostly implemented as an API demonstration.
 */
public class Info {

    public static void main(String[] paths) {
        Arrays.stream(paths)
                .map(Info::mapPathToReader)
                .forEach(pdfReader -> {
                    System.out.println("Title: " + getTitle(pdfReader));
                    System.out.println("Pages: " + pdfReader.getNumberOfPages());

                    getFirstPage(pdfReader).ifPresent(rectangle -> {
                        System.out.println("Width: " + rectangle.getWidth());
                        System.out.println("Height: " + rectangle.getHeight());
                    });

                    System.out.println();
                });
    }

    /**
     * @param reader Non null.
     * @return The "Title" value as found in the PDF document information.
     */
    private static String getTitle(PdfDocument reader) {
        final PdfDocumentInfo documentInfo = reader.getDocumentInfo();
        return documentInfo.getTitle();
    }

    private static Optional<Rectangle> getFirstPage(PdfDocument document) {
        if (document.getNumberOfPages() < 1) {
            return Optional.empty();
        }
        final PdfPage firstPage = document.getFirstPage();
        return Optional.ofNullable(firstPage.getPageSize());
    }

    /**
     * Maps a file path location to a PDFReader that represents the document provided.
     *
     * @param path
     * @return
     */
    public static PdfDocument mapPathToReader(String path) {
        return mapToPdfReader(mapToFileStream(path));
    }

    public static PdfDocument mapPathToWriter(String path) {
        try {
            return new PdfDocument(new PdfWriter(path));
        } catch (FileNotFoundException e) {
            throw new IllegalStateException(e);
        }
    }

    public static PdfDocument mapToPdfReader(FileInputStream fileInputStream) {
        try {
            final PdfReader reader = new PdfReader(fileInputStream);
            return new PdfDocument(reader);
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public static FileInputStream mapToFileStream(String s) {
        try {
            return new FileInputStream(s);
        } catch (FileNotFoundException e) {
            throw new IllegalStateException(e);
        }
    }
}
