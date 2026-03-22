package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}
%state COMMENT
%state NESTED_COMMENT

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]



Init = "init"
Float = "Float"
Int = "Int"
String = "String"
Write = "write"
Read = "read"
While = "while"
If = "if"
Else = "else"
Not = "NOT"
Or = "OR"
And = "AND"

OpenComment = "#+"
CloseComment = "+#"
GreaterOrEqual = ">="
LessOrEqual = "<="
Equal = "=="
NotEqual = "!="


Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Assig = ":="
OpenParenthesis = "("
CloseParenteshis = ")"
OpenBracket = "["
CloseBracket = "]"
OpenBrace = "{"
CloseBrace = "}"
Comma = ","
Colon = ":"
Greater = ">"
Less = "<"


Letter = [a-zA-Z]
Digit = [0-9]


WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+
FloatConstant = {Digit}+\.{Digit}* | {Digit}*\.{Digit}+
StringConstant = \"[\x20-\x7E]*\"
%%


/* keywords */

<YYINITIAL> {

  /* keywords */
  {Init}                                    { return symbol(ParserSym.INIT); }
  {Float}                                   { return symbol(ParserSym.FLOAT); }
  {Int}                                     { return symbol(ParserSym.INT); }
  {String}                                  { return symbol(ParserSym.STRING); }
  {Read}                                    { return symbol(ParserSym.READ); }
  {Write}                                   { return symbol(ParserSym.WRITE); }
  {While}                                   { return symbol(ParserSym.WHILE); }
  {If}                                      { return symbol(ParserSym.IF); }
  {Else}                                    { return symbol(ParserSym.ELSE); }
  {Not}                                     { return symbol(ParserSym.NOT); }
  {Or}                                      { return symbol(ParserSym.OR); }
  {And}                                     { return symbol(ParserSym.AND); }

   /* operators */
  {Greater}                                 { return symbol(ParserSym.GREATER); }
  {GreaterOrEqual}                          { return symbol(ParserSym.GREATER_OR_EQUAL); }
  {Less}                                    { return symbol(ParserSym.LESS); }
  {LessOrEqual}                             { return symbol(ParserSym.LESS_OR_EQUAL); }
  {Equal}                                   { return symbol(ParserSym.EQUAL); }
  {NotEqual}                                { return symbol(ParserSym.NOT_EQUAL); }

   
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Assig}                                   { return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }
  {OpenBrace}                               { return symbol(ParserSym.OPEN_BRACE); }
  {CloseBrace}                              { return symbol(ParserSym.CLOSE_BRACE); }
  {OpenParenthesis}                         { return symbol(ParserSym.OPEN_PARENTHESIS); }
  {CloseParenteshis}                        { return symbol(ParserSym.CLOSE_PARENTHESIS); }
  {Comma}                                   { return symbol(ParserSym.COMMA); }
  {Colon}                                   { return symbol(ParserSym.COLON); }
  {OpenComment}                             { yybegin(COMMENT); }


  /* identifiers */
  {Identifier}                              { return symbol(ParserSym.IDENTIFIER, yytext()); }
  /* Constants */
  {IntegerConstant}                         { return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }
  {FloatConstant}                           { return symbol(ParserSym.FLOAT_CONSTANT, yytext()); }
  {StringConstant}                          { return symbol(ParserSym.STRING_CONSTANT, yytext()); }



  /* whitespace */
  {WhiteSpace}                              { /* ignore */ }
}

<COMMENT> {
  {OpenComment}                             { yybegin(NESTED_COMMENT); }
  {CloseComment}                            { yybegin(YYINITIAL); } 
  [^]                                       { /* ignore */ }

}

<NESTED_COMMENT> {
  {OpenComment}                             { throw new InvalidNestedComment("No se permite anidar comentarios más de un nivel"); }
  {CloseComment}                            { yybegin(COMMENT); } 
  [^]                                       { /* ignore */ }
}

/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext(), yyline, yycolumn); }
