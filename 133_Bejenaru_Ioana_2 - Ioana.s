.data
  n: .space 4 
  m: .space 4
  p: .space 4
  k: .space 4
  m2: .space 4
  n2: .space 4
  matrix1: .space 1000
  matrix2: .space 1000
  i: .space 4
  j: .space 4
  ct: .space 4
  val: .space 4
  suma_vecini: .space 4
  suma_matrix2: .space 4
  formatPrintf: .asciz "%ld "
  formatScanf: .asciz "%ld"
  newline: .asciz "\n"

  #date in plus pentru a citi din fisier si pt a afisa in fisier
  nume_fisier_in: .asciz "in.txt"
  nume_fisier_out: .asciz "out.txt"
  in_pointer: .space 4
  out_pointer: .space 4
  citire: .asciz "r"
  afisare: .asciz "w"
  formatPrintfSir: .asciz "%s"  #pentru newline
  af: .space 4
  #n=numar de coloane, m=numar de linii
  #p=numar celule cu 1 initial
  #k=pasii evolutiei
  #i=pt linii si j=pt coloane
  #val= voi avea numarul pe care daca il inmultesc cu 4
  #     imi arata unde se afla in memorie elem de la i,j
  #     si ma va ajuta sa calc cei 8 vecini

.text


.global main

main:
  
  #deschidd fisierul pentru a citi

  push $citire
  push $nume_fisier_in
  call fopen
  pop %ebx
  pop %ebx
  movl %eax, in_pointer


  #punem cu "$" pt a ne modifica val direct in memorie
 
  push $m 
  push $formatScanf
  push in_pointer
  call fscanf
  pop %ebx
  pop %ebx
  pop %ebx

  push $n
  push $formatScanf
  push in_pointer
  call fscanf
  pop %ebx
  pop %ebx
  pop %ebx

  #pentru ca bordam matricile incrementam cu 2 n si m
  movl n, %eax
  addl $2, %eax
  movl %eax, n2
  
  movl m, %eax
  addl $2, %eax
  movl %eax, m2

  push $p
  push $formatScanf
  push in_pointer
  call fscanf
  pop %ebx
  pop %ebx
  pop %ebx

  movl $0, ct

 
citirea_celulelor:

  movl ct, %ecx
  cmp %ecx, p
  je continuare_citire

  push $i
  push $formatScanf
  push in_pointer
  call fscanf
  pop %ebx
  pop %ebx
  pop %ebx
 
  push $j
  push $formatScanf
  push in_pointer
  call fscanf
  pop %ebx
  pop %ebx
  pop %ebx

  #cum voi lucra cu matricea bordata trebuie sa cresc i si j
     
  movl i, %eax
  inc %eax
  movl %eax, i

  movl j, %eax
  inc %eax
  movl %eax, j

  #acum voi completa cu 1 in matrix1
  #pe ea vom verifica celulele
  #modificarile se vor produce in matrix2 (pt a nu influenta celulele urmatoare
  #si dupa vom copia matrix2 in matrix1

  #aici vom reprezenta in memorie folosind formula a(b,c,d)= b+c*d+a

  movl i, %eax
  xor %edx, %edx
  mull n2 
  addl j, %eax
  lea matrix1, %edi
  movl $1, (%edi, %eax, 4)

  #continuam procesul simuland un for pana cand am citit toate  perechile de p ori

  movl ct, %eax
  inc %eax
  movl %eax, ct
  jmp citirea_celulelor

continuare_citire:

  push $k
  push $formatScanf
  push in_pointer
  call fscanf
  pop %ebx
  pop %ebx
  pop %ebx

#acum simulez forul pt k
#si as vrea cumva daca matrix2 ajunge toata nula
#sa am grija sa o copiez in matrix1 si sa opresc forul

movl $0, ct

for_k:
  movl $0, suma_matrix2
  movl ct, %ecx
  cmp %ecx, k
  je afisare_matrice

  parcurgere_matrix1:
     movl $1, i
     liniik:
       movl i, %ecx
       cmp  m, %ecx
       jg copiere_matrice

       movl $1, j 
       coloanek:

         movl j, %ecx
         cmp n, %ecx
         jg incrementare
    
         movl $0, suma_vecini
         
         movl i, %eax
         xor %edx, %edx
         mull n2
         addl j, %eax
         
         #tin minte aici val lui eax pt a putea accesa cei 8 vecini 
         movl %eax, val
         
         lea matrix1, %edi
         
         #vecinul i, j+1
         movl val, %eax
         inc %eax
         movl (%edi, %eax, 4), %ebx
                  
         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini
 
         #vecinul i+1,j+1
         movl val, %eax
         addl n2, %eax
         addl $1, %eax
         movl (%edi, %eax, 4), %ebx
       
         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini

         #vecinul  i+1,j
         movl val, %eax
         addl n2, %eax
         movl (%edi, %eax, 4), %ebx
        
         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini
    
         #vecinul i+1,j-1
         movl val, %eax
         addl n2, %eax
         subl $1, %eax
         movl (%edi, %eax, 4), %ebx
  
         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini

         #vecinul i,j-1
         movl val, %eax
         sub $1, %eax
         movl (%edi, %eax, 4), %ebx

         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini

         #vecinul  i-1,j-1
         movl val, %eax
         subl $1, %eax
         subl n2, %eax
         movl (%edi, %eax, 4), %ebx

         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini

         #vecinul i-1,j
         movl val, %eax
         subl n2, %eax
         movl (%edi, %eax, 4), %ebx
 
         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini

         #vecinul i-1, j+1
         movl val, %eax
         subl n2, %eax
         addl $1, %eax
         movl (%edi, %eax, 4), %ebx

         movl suma_vecini, %ecx
         addl %ebx, %ecx
         movl %ecx, suma_vecini
         
         test_suma:
         #acum ca am calculat suma trebuie sa verific ce fel de celula e
         #si sa completez in matrix2
         
         #preiau ce val are celula curenta
         movl val, %eax
         movl (%edi, %eax, 4), %ebx
         lea matrix2, %edi
         
         cmp $1, %ebx
         je celula1

         movl suma_vecini, %ebx
         cmp $3,%ebx
         je creare

         movl $0, (%edi, %eax, 4)
         jmp incj 
         
         creare:
         movl $1, (%edi, %eax, 4)
         incl suma_matrix2
         jmp incj 

         celula1:
         movl suma_vecini, %ebx
         cmp $2,%ebx
         jl subpopulare
         
         movl suma_vecini, %ebx
         cmp $3, %ebx
         jg ultrapopulare

         movl $1, (%edi, %eax, 4)
         incl suma_matrix2
         jmp incj

         subpopulare:
         movl $0, (%edi, %eax, 4)
         jmp incj

         ultrapopulare:
         movl $0, (%edi, %eax, 4)
         jmp incj

         incj:
         incl j
         jmp coloanek

       incrementare:
          movl i, %eax
          inc %eax
          movl %eax, i
          jmp liniik

copiere_matrice:
  movl $1, i
  copie_linii:
    movl i, %ecx
    cmp m, %ecx
    jg verificare

    movl $1, j
    copie_coloane:
      movl j, %ecx
      cmp n, %ecx
      jg copie_inc

      movl i, %eax
      xor %edx, %edx
      mull n2
      addl j, %eax

      #copiem ce se afla la poz i,j in matrix2 in matrix1
      lea matrix2, %edi
      movl (%edi, %eax, 4), %ebx
      
      lea matrix1, %edi
      movl %ebx, (%edi, %eax, 4)

      incl j
      jmp copie_coloane

      copie_inc:
      incl i
      jmp copie_linii

verificare:
  incl ct
  movl suma_matrix2, %eax
  cmp $0, %eax
  je afisare_matrice
  jmp for_k


afisare_matrice:

  #intai deschid fisierul pentru afisare

  push $afisare
  push $nume_fisier_out
  call fopen
  pop %ebx
  pop %ebx
  movl %eax, out_pointer

  movl $1, i
  linii:
    movl i, %ecx
    cmp m, %ecx
    jg et_exit

    movl $1, j
    coloane:
        movl j, %ecx
        cmp n, %ecx
        #pentru a afisa pe linia urmatoare
        jg linie_noua
        
 
        #calcularea si afisarea fiecarui element
        movl i, %eax
        xor %edx, %edx
        mull n2
        addl j, %eax
        lea matrix1, %edi
        movl (%edi, %eax, 4), %ebx
        
        movl %ebx, af
        aici: 
        push af
        push $formatPrintf
        push out_pointer
        call fprintf
        pop %ebx
        pop %ebx
        pop %ebx
        
        pushl $0
        call fflush
        popl %ebx

        movl j, %eax
        inc %eax
        movl %eax, j
        jmp coloane

  linie_noua:
    
    push $newline
    push $formatPrintfSir
    push out_pointer
    call fprintf
    pop %ebx
    pop %ebx
    pop %ebx

    pushl $0
    call fflush
    popl %ebx

    movl i, %eax
    inc %eax
    movl %eax, i
    jmp linii
      
         

et_exit:

  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
