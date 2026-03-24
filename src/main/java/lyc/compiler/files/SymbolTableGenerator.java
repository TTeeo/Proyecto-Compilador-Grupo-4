package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;
import lyc.compiler.files.SymbolTableManager;
import lyc.compiler.files.DataType;


public class SymbolTableGenerator implements FileGenerator{
    
    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        fileWriter.write(String.format("%-15s  %-10s  %-50s  %-10s\n",
                "NOMBRE", "TIPODATO", "VALOR", "LONGITUD"));

        String name, type, value, length;

        for(SymbolEntry entry : SymbolTableManager.getSymbols().values()){
   
            name = entry.getName();
            type = entry.getDataType().toString();
            length = Integer.toString(entry.getLength());

            if(entry.getValue() != null)
                value = entry.getValue().toString();
            else
                value = "-";   

            if( entry.getDataType() != DataType.STRING || entry.getValue() == null)
                length = "-";
            
            
            fileWriter.write(String.format("%-15s  %-10s  %-50s  %-10s\n",
                    name, type, value, length));
        }
    }
}
