package store.admin.utils;

import lombok.extern.slf4j.Slf4j;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import utils.Lang;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * @author: taofeng
 * @create: 2019-08-30
 **/
@Slf4j
@Component
public class ExcelUtils {

    public ByteArrayOutputStream excelForSXSSFWorkbook(String fileName, List<List<Object>> rows) {
        SXSSFWorkbook workbook = null;
        ByteArrayOutputStream outputStream = null;
        try {
            ClassPathResource resource = new ClassPathResource(fileName);
            InputStream inputStream = resource.getInputStream();
            XSSFWorkbook wb = new XSSFWorkbook(inputStream);
            workbook = new SXSSFWorkbook(wb);
            outputStream = new ByteArrayOutputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Font font = workbook.createFont();
        font.setFontName("宋体");//设置字体名称
        font.setFontHeightInPoints((short) 12);//设置字号
        CellStyle style = workbook.createCellStyle();
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER); // 居中
        style.setVerticalAlignment(VerticalAlignment.CENTER); //垂直居中
        style.setWrapText(true);//自动换行
        style.setBorderBottom(BorderStyle.THIN); //下边框
        style.setBorderLeft(BorderStyle.THIN);//左边框
        style.setBorderTop(BorderStyle.THIN);//上边框
        style.setBorderRight(BorderStyle.THIN);//右边框
        SXSSFSheet sheet = workbook.getSheetAt(0);
        SXSSFRow row;//行
        SXSSFCell cell;//单元格
        int rowIdx = 1;
        for (List<Object> dr : rows) {
            row = sheet.createRow(rowIdx);
            for (int di = 0; di < dr.size(); di++) {
                cell = row.createCell(di);
                cell.setCellStyle(style);
                String cellValue = "";
                if (Lang.isEmpty(dr.get(di))) {
                    cellValue = "";
                } else {
                    cellValue = dr.get(di) + "";
                }
                cell.setCellValue(new XSSFRichTextString(cellValue));
            }
            rowIdx++;
        }
        try {
            workbook.write(outputStream);
            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                workbook.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return outputStream;
    }

}
