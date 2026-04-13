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

    //Verificar que pasa cuando quiero agregar una constante string "_5" si es la tabla ya existe una constante entera "_5",
    //pero que ambos representan contenidos diferentes.
    public static String buildConstantKey(String name, DataType dataType){
        return "_" + dataType.toString() + "_" + name;
    }


    //Insertar para Constantes
    public static void insertConstantInTable(Object value, DataType dataType){
        String name = value.toString();
        if(!existsInTable(buildConstantKey(name, dataType))){
            SymbolEntry symbol = new SymbolEntry(buildConstantKey(name, dataType), dataType, value);
            symbols.put(name, symbol);
        }
    }

    //Insertar para Identificadores
    public static void insertIdentifierInTable(String name, DataType dataType) throws DuplicatedIdentifierException{
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