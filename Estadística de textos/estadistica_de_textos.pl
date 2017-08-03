#!/usr/bin/perl
use utf8;

#abrir archivo
my $archivo = 'iula/ES.txt';
open (FILE, $archivo) || die "$!\n";
my @content = <FILE>;

#crear el hash que uso para guardar la cuenta de las palabras las cuales seran la clave.
%hash=();
#contador de palabras
$cont=0;
#contador de caracteres
$cont_char=0;

for $a (@content){

	#contar los caracteres de cada linea.
	$cont_char+=length($a);
	#separar las palabras por todo lo que no sea una letra.
	@temp = split(/[^a-zA-Z]/,$a);
	for $j (@temp){

		#contar palabra y poner todas las letras minusculas para que no distinga entre mayusculas y minusculas.
		$cont++;
		$j = lc $j;
		#si el hash no tiene la palabra la añade con el valor 1 y si la tiene incrementa en 1 su valor.
		if($hash{$j}==null){

			$hash{$j}=1;
		}else{

			$hash{$j}++;
		}
	}
}
#imprimir el numero de palabras y caracteres.
printf "%010d	Total de palabras\n%010d	Número de caracteres\n",$cont, $cont_char;

#imprimir la lista de palabras con su respectivo numero en orden de repeticiones.
foreach my $word (sort {$hash{$a} <=>$hash{$b} } keys %hash) {

	if($hash{$word}!=" "){
		printf "%010d	%s\n",$hash{$word}, $word;
	}
}
