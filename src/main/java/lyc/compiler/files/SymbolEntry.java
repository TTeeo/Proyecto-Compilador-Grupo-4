package lyc.compiler.files;

import lyc.compiler.files.DataType;

final class SymbolEntry {

    private final String name;
    private final DataType dataType;
    private Object value;
    private int length;

    //Constructor para Identificador.
    SymbolEntry(String name, DataType dataType){
        this.name = name;
        this.dataType = dataType;
        this.value = null;
        this.length = 0;
    }

    //Constructor para Constante
    SymbolEntry(String name, DataType dataType, Object value){
        this.name = "_" + name;
        this.dataType = dataType;
        this.value = value;

        if( dataType == DataType.STRING ){
            this.length = ((String) value).length();
        }
        else{
            this.length = 0;
        }
    }

    public String getName(){
        return this.name;
    }

    public DataType getDataType(){
        return this.dataType;
    }

    public Object getValue(){
        return this.value;
    }

    public int getLength(){
        return this.length;
    }
}
