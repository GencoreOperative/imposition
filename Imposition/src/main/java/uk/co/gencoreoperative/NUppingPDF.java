package uk.co.gencoreoperative;


import com.itextpdf.kernel.geom.AffineTransform;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfPage;
import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
import com.itextpdf.kernel.pdf.xobject.PdfFormXObject;

public class NUppingPDF {
    public static void main(String args[]) throws Exception {
        if (args.length == 0) {
            return;
        }
        try (PdfDocument srcPdf = Info.mapPathToReader(args[0]);
             PdfDocument destpdf = Info.mapPathToWriter("nmap.pdf")) {

            // Opening a page from the existing PDF
            PdfPage origPage = srcPdf.getFirstPage();
            Rectangle orig = origPage.getPageSize();
            PdfFormXObject pageCopy = origPage.copyAsFormXObject(destpdf);

            // N-up page
            final PageSize nUpPageSize = PageSize.A4;
            PdfPage page = destpdf.addNewPage(nUpPageSize);
            PdfCanvas canvas = new PdfCanvas(page);

            // Scale page
            // Note: Angle is in Radians
            final double left = Math.toRadians(90);
            final double right = Math.toRadians(-90);

//            AffineTransform rotateTransform = AffineTransform.getRotateInstance(right, nUpPageSize.getWidth()/2, nUpPageSize.getHeight()/2);
//            AffineTransform rotateTransform = AffineTransform.getRotateInstance(Math.toRadians(-90));

//            AffineTransform transformationMatrix = AffineTransform.getScaleInstance(
//                    nUpPageSize.getWidth() / orig.getWidth() / 2f,
//                    nUpPageSize.getHeight() / orig.getHeight() / 2f);
//
//            transformationMatrix.concatenate(rotateTransform);

            final AffineTransform scaleInstance = AffineTransform.getScaleInstance(
                    nUpPageSize.getWidth() / orig.getWidth() / 2,
                    nUpPageSize.getHeight() / orig.getHeight() / 2);
//            rotateTransform.concatenate(scaleInstance);

            AffineTransform half = AffineTransform.getScaleInstance(
                    nUpPageSize.getHeight() / orig.getWidth(),);

            canvas.concatMatrix(scaleInstance);

//            AffineTransform scaleTransform = AffineTransform.getScaleInstance(0.5, 0.5);

//            scaleTransform.concatenate(rotateTransform);

//            canvas.concatMatrix(transformationMatrix);

            // Add pages to N-up page
//            canvas.addXObject(pageCopy, 0, orig.getHeight());
//            canvas.addXObject(pageCopy, orig.getWidth(), orig.getHeight());
            canvas.addXObject(pageCopy, 0, 0);
//            canvas.addXObject(pageCopy, orig.getWidth(), 0);

            // Suspect that if the object is half off the top or bottom of the page, it is not printed at all.
            // printing half off the right seems ok.
        }
    }
}
