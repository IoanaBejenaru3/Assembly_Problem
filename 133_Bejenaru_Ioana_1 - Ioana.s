.data
  n: .space 4 
  m: .space 4
  p: .space 4
  k: .space 4
  m2: .space 4
  n2: .space 4
  mesaj: .space 50
  cod: .space 4
  lg: .space 4
  poz: .space 4
  elem: .space 4
  matrix1: .space 1000
  matrix2: .space 1000
  matrix3: .space 1000
  i: .space 4
  j: .space 4
  ct: .space 4
  val: .space 4
  suma_vecini: .space 4
  suma_matrix2: .space 4
  formatPrintf: .asciz "%ld "
  formatScanf: .asciz "%ld"
  formatScanfSir: .asciz "%s"
  formatPrintfSir: .asciz "%s"
  newline: .asciz "\n"
  #n=numar de coloane, m=numar de linii
  #p=numar celule cu 1 initial
  #k=pasii evolutiei
  #i=pt linii si j=pt coloane
  #val= voi avea numarul pe care daca il inmultesc cu 4
  #     imi arata unde se afla in memorie elem de la i,j
  #     si ma va ajuta sa calc cei 8 vecini
  #cod= vom citi 0 sau 1, 0 -  criptare, 1 - decriptare
  #mesaj= ceea ce citim pt a efectua criptare/decriptare
  #lg= lungimea mesajului citit
  #elem=nr elem din matricea bordata
  #matrix3= unde vom avea rezultatul task-ului 1

.text

.global main

main:

  #punem cu "$" pt a ne modifica val direct in memorie
 
  push $m 
  push $formatScanf
  call scanf
  pop %ebx
  pop %ebx

  push $n
  push $formatScanf
  call scanf
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
  call scanf
  pop %ebx
  pop %ebx

  movl $0, ct

 
citirea_celulelor:

  movl ct, %ecx
  cmp %ecx, p
  je continuare_citire

  push $i
  push $formatScanf
  call scanf
  pop %ebx
  pop %ebx
 
  push $j
  push $formatScanf
  call scanf
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
  call scanf
  pop %ebx
  pop %ebx

  push $cod
  push $formatScanf
  call scanf
  pop %ebx
  pop %ebx

  push $mesaj
  push $formatScanfSir
  call scanf
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
  je continuare_task

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
  je continuare_task
  jmp for_k
 

continuare_task:

  movl cod, %eax
  cmp $0, %eax
  je criptare
  jmp decriptare

criptare:

  movl $0, lg
  xor %eax, %eax
  mov $mesaj, %esi
  aflare_lungime:
    xor %ecx, %ecx
    movb (%esi, %eax, 1), %cl
    cmp $0, %ecx
    je comparare 
    incl lg
    incl %eax
    jmp aflare_lungime

  comparare:
    movl n2, %eax
    xor %edx, %edx
    mull m2
    movl %eax, elem

    movl lg, %eax
    xor %edx, %edx
    movl $8, %ecx
    mul %ecx
    cmp elem, %eax
    jle decide


  completare:
    #acum voi completa in memorie in continuare la matrix2 cu valori pentru a egala mesajul
    #locatia in memorie incepe de la elem
    #trebuie sa completez cu %eax-elem  
    #daca cheia este mai lunga decat mesajul sarim peste completare si trecem la xorare

    subl elem, %eax
    movl $0, ct
    movl %eax, %ecx    

    pune:
    cmp ct, %ecx
    je decide
    
    lea matrix2, %edi
    movl ct, %eax
    movl (%edi, %eax, 4), %ebx
    movl elem, %eax
    movl %ebx, (%edi, %eax, 4)

    incl elem
    incl ct
    jmp pune

    decide:
    movl cod, %eax
    cmp $0, %eax
    je xorare
    jmp aflare

    xorare:
    movl $0,ct

    #poz= poziiile din matrix3    

    #aici facem "0x" pentru sirul hexa    
    lea matrix3, %edi
    xor %eax, %eax
    movb $48, (%edi, %eax, 1)
    incl %eax
    movb $120, (%edi, %eax, 1)
    movl $2, poz
    movl $0, i
    #cu i voi merge in memorie prin matrix2

    for_lg:
    movl ct, %ecx
    cmp lg, %ecx
    je afisare

    movl ct, %eax    
    xor %ebx, %ebx
    xor %edx, %edx

    lea mesaj, %edi
    movb (%edi, %eax, 1), %bl

    #trebuie sa iau cate 8 valori
    movl $0, j
    preluare:
    movl j, %ecx
    cmp $8, %ecx
    je cont
     
    lea matrix2, %edi
    movl i, %eax
    shl $1, %edx
    movl (%edi, %eax, 4), %ecx
    addl %ecx, %edx
    incl i
    incl j
    jmp preluare


    cont:
    xor %edx, %ebx
    
    shl $4, %ebx
    
    #adaug poz in eax pt a adauga in memorie
    movl poz, %eax

    # eu am asa in bx: in bh primii 4 biti shiftati, si in bl urm 4 dar trebuie sa le modific putin pozitia
    #totusi am nev de codurile ascii ale numerelor/literelor pt a le putea afisa bine
    #deci daca am o val intre 0-9 ii adaug 48
    #mai sus adaug 55 pt a transf in litera mare
    #trebuie sa adaug la val din

    cmp $9, %bh
    jg litera

    addb $48, %bh
    jmp adauga

    litera:
    addb $55, %bh
 
    adauga:
    lea matrix3, %edi
    movb %bh, (%edi, %eax, 1)
    
    #acum urm 4 biti
    xor %edx, %edx 
    incl poz
    movl poz, %eax
   
    movb %bl, %dl
    shr $4, %edx

    cmp $9, %edx
    jg litera2

    addl $48, %edx
    jmp adauga2

    litera2:
    addl $55, %edx
    
    adauga2:
    lea matrix3, %edi
    movb %dl, (%edi, %eax, 1)

    incl poz
    incl ct
    jmp for_lg

    
    
decriptare:

  #pasii pentru a ajunge la parola 
  #construiesc cheia in matrix3
  #stiu ca in mesaj am un numar hexazecial pe care trebuie sa il aduc in binar
  #stiu ca peste primii 16 biti sar pt ca au "0x" de la hexazecimal
  #poz ma ajuta sa parcurg ceea ce am de decrriptat iar lg ma ajuta sa stiu unde trebuie sa pun in memorie in matrix3

  movl $2, poz
  movl $0, lg    
  binar:
  xor %ebx, %ebx
  xor %edx, %edx 
  movl poz, %eax
  lea mesaj, %edi
  movb (%edi, %eax, 1), %bl

  #daca ajunge sa fie 0 inseamna ca am terminat ce am citit
  cmp $0, %bl
  je comparare 
  
  #acum avem codul ascii al literei/cifrei in bl
  #deci trebuie sa aducem la nr corescpunzator -48 daca este  cifra -55 daca este litera

  # testare daca am val buna (codul ascii corescp a ceea ce trebuie afisat

   cmp $57, %bl
   jg literad
 
   subb $48, %bl
   jmp urm   

   literad:
   subb $55, %bl   
  
  
   urm:
   #shiftam 4 poz la stanga pt a face loc urm 4 biti pe care o sa i punem
   shl $4, %bl
   
   lea mesaj, %edi
   incl poz
   movl poz, %eax
   movb (%edi, %eax, 1), %dl
   
   #trebuie sa fac aceeasi trasnformare

   cmp $57, %dl
   jg literad2

   subb $48, %dl
   jmp cont_binar   

   literad2:
   subb $55, %dl

   cont_binar:
   #acum adunam ce avem in bl cu dl pt a obtine o secv de 8 biti pe care o mutam in matrix3

   lea matrix3, %edi
   addb %dl, %bl
   movl lg, %eax
   movb %bl, (%edi, %eax, 1)

   incl lg
   incl poz
   jmp binar

   aflare:

   movl $0, ct
   movl lg, %ecx
   movl %ecx, poz
   movl $0, i
   
   for_aflare:
   movl ct, %eax
   cmp lg, %eax
   je afisare
   
   xor %ebx, %ebx
   xor %edx, %edx

   lea matrix3, %edi
   movl ct, %eax
   movb (%edi, %eax, 1), %bl
  
   
   movl $0,j
   
   preluare_2:
   movl j, %eax
   cmp $8, %eax
   je aici

   movl i, %eax
   lea matrix2, %edi
   shl $1, %edx
   movl (%edi, %eax, 4), %ecx
   addl %ecx, %edx

   incl i
   incl j
   jmp preluare_2
 
   aici:
   xor %ecx, %ecx
   movl $0, j


   test:
   movl j, %eax
   cmp $8, %eax
   je plaseaza
   
   mama:
   xor %bh, %bh
   xor %dh, %dh
   shl $1, %ebx
   shl $1, %ecx
   shl $1, %edx

   addb %dh, %bh
   cmp $1, %bh
   jne nupune1
   
   addl $1, %ecx
   
   nupune1:
   incl j
   jmp test

   
   plaseaza:
   lea matrix3, %edi
   movl ct, %eax
   movb %cl, (%edi, %eax, 1)
   incl ct
   jmp for_aflare 
   

afisare:

   lea matrix3, %edi
   movl poz, %eax
   movb $10, (%edi, %eax, 1)
    
   push $matrix3
   push $formatPrintfSir
   call printf
   pop %ebx
   pop %ebx

   push $0
   call fflush
   pop %ebx
  

et_exit:

  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
