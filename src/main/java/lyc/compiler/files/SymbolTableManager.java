package lyc.compiler.files;

import java.util.HashMap;
import java.util.Map;
import lyc.compiler.model.DuplicatedIdentifierException;

public final class SymbolTableManager {

    private static Map<String, SymbolEntry> symbols = new HashMap<>();

    private SymbolTableManager() {}

    public static boolean existsInTable(String name){
        return symbols.containsKey(name);
    }

    //Insertar para Constantes
    public static void insertInTable(String name, DataType dataType, Object value){
      
        if(!existsInTable(name)){
            SymbolEntry symbol = new SymbolEntry(name, dataType, value);
            symbols.put(name, symbol);
        }
    }

    //Insertar para Identificadores
    public static void insertInTable(String name, DataType dataType) throws DuplicatedIdentifierException{
        if(!existsInTable(name)){
            SymbolEntry symbol = new SymbolEntry(name, dataType);
            symbols.put(name, symbol);
        }
        else{
            throw new DuplicatedIdentifierException("El identificador " + name + " ya fue declarado.");
        }
    }
    public static Map<String, SymbolEntry> getSymbols(){
        return symbols;
    }
}