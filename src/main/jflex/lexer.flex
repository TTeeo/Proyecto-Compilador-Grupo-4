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

Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Assig = ":="
OpenBracket = "("
CloseBracket = ")"
OpenBrace = "{"
CloseBrace = "}"
Comma = ","
Colon = ":"
OpenComment = "#+"
CloseComment = "+#"

Letter = [a-zA-Z]
Digit = [0-9]

Init = "init"
Float = "Float"
Int = "Int"
String = "String"



WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+
FloatConstant = {Digit}+\.{Digit}* | {Digit}*\.{Digit}+
StringConstant = \"[\x20-\x7E]*\"

%%


/* keywords */

<YYINITIAL> {

  {Init}                                    { return symbol(ParserSym.INIT); }
  {Float}                                   { return symbol(ParserSym.FLOAT); }
  {Int}                                     { return symbol(ParserSym.INT); }
  {String}                                  { return symbol(ParserSym.STRING); }


  /* identifiers */
  {Identifier}                              { return symbol(ParserSym.IDENTIFIER, yytext()); }
  /* Constants */
  {IntegerConstant}                         { return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }
  {FloatConstant}                           { return symbol(ParserSym.FLOAT_CONSTANT, yytext()); }
  {StringConstant}                          { return symbol(ParserSym.STRING_CONSTANT, yytext()); }

  /* operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Assig}                                   { return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }
  {OpenBrace}                               { return symbol(ParserSym.OPEN_BRACE); }
  {CloseBrace}                              { return symbol(ParserSym.CLOSE_BRACE); }
  {Comma}                                   { return symbol(ParserSym.COMMA); }
  {Colon}                                   { return symbol(ParserSym.COLON); }
  {OpenComment}                             { yybegin(COMMENT); }


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
