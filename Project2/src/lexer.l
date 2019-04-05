%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
symtab * lookup();
symtab * ptr;
void     insertID();
void 	 printSymTab();
/* You need to define for all tokens in C--, here are some examples */
#define INT		10
#define FLOAT 		11 
#define OP_ASSIGN 	12 
#define OP_OR 		13 
#define MK_LPAREN 	14 
#define MK_RPAREN 	15 
#define ERROR 		100 

%}

reserved_word return|typedef|if|else|int|float|for|void|while

letter   [A-Za-z]
digit    [0-9]
hex_digit [0-9a-fA-F]
ID	 ({letter}|_)({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+

Digit_sequence {digit}+
Frac_constant ({digit}+\.{digit}*)|(\.{digit}+)
Exp_part [Ee][+-]?{Digit_sequence}
Float_constant (({Frac_constant}{Exp_part}?)|({Digit_sequence}{Exp_part}))[FfLl]?

Control_char \\([^x]|(x{hex_digit}))
String_constant \"([^"\\]|{Control_char})*\"

Inline_comment \/\/(.|(\\\n))*
Block_comment "/*"([^*]|([*]*[^/*]))*[*]*\/
Comment ({Inline_comment})|({Block_comment})

OP_assign        "="
OP_or   "||"
OP_and   "&&"
OP_not   "!"
OP_add   "+"
OP_sub   "-"
OP_mul   "*"
OP_div   "/"
OP_ls   "<"
OP_leq   "<="
OP_eq   "=="
OP_geq   ">="
OP_gt   ">"

newline  "\n"

DL_lparen "("
DL_rparen ")"
DL_lbrace "{"
DL_rbrace "}"
DL_comma  ","
DL_semicol ";"
DL_dot  "."


error    .

%%

{WS} {}
{reserved_word} {}
{Comment} {printf("%s\n",yytext);}
{ID}            { 
            printf("Identifier: %s\n",yytext);
			ptr = lookup(yytext);
			if (ptr == NULL)
			     insertID(yytext);	
			else 
			     ptr->counter++;
		}
{newline}       {linenumber += 1;}
{letter} {}
{digit} {}
{hex_digit} {}
{Int_constant} {}
{Digit_sequence} {}
{Frac_constant} {}
{Exp_part} {}
{Float_constant} {}
{Control_char} {}
{String_constant} {}
{Inline_comment} {}
{Block_comment} {}
{OP_assign} {}
{OP_or} {}
{OP_and} {}
{OP_not} {}
{OP_add} {}
{OP_sub} {}
{OP_mul} {}
{OP_div} {}
{OP_ls} {}
{OP_leq} {}
{OP_eq} {}
{OP_geq} {}
{OP_gt} {}
{DL_lparen} {}
{DL_rparen} {}
{DL_lbrace} {}
{DL_rbrace} {}
{DL_comma} {}
{DL_semicol} {}
{DL_dot} {}
{error}         {printf("Undefined token \"%s\"\n",yytext);exit(-1);}

%%

main(int argc, char **argv)
{
 argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   yylex();
   printSymTab();
}

