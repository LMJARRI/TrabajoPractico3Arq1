.data
slist: .word 0
cclist: .word 0
wclist: .word 0
schedv: .space 32
menu:.ascii "\nColecciones de objetos categorizados\n"
 .ascii "====================================\n"
 .ascii "1-Nueva categoria\n"
 .ascii "2-Siguiente categoria\n"
 .ascii "3-Categoria anterior\n"
 .ascii "4-Listar categorias\n"
 .ascii "5-Borrar categoria actual\n"
 .ascii "6-Anexar objeto a la categoria actual\n"
 .ascii "7-Listar objetos de la categoria\n"
 .ascii "8-Borrar objeto de la categoria\n"
 .ascii "0-Salir\n"
 .asciiz "Ingrese la opcion deseada: "
 
opcion1:.asciiz "\n-Agregar una nueva catogoria\n"
opcion2:.asciiz "\n- Siguiente categoria\n"
opcion3:.asciiz "\n- Categoria anterior\n"
opcion4:.asciiz "\n- Listar categorias\n"
opcion5:.asciiz "\n- Borrar categoria actual\n"
opcion6:.asciiz "\n- Anexar objetos a la categoria actual\n"
opcion7:.asciiz "\n-Listar objetos de las categorias\n"
opcion8:.asciiz "\n- Borrar objeto de la categoria\n"

 #Para seleccionar una categoria
 msjCatSig:.asciiz "Has pasado a la siguiente categoria"
 msjCatAnt:.asciiz "Has pasado a la anterior categoria"
 msjError201:.asciiz "\nError201:No hay categorias"
 msjError202:.asciiz "\nError202:Solo hay una categoria"
 msjError301:.asciiz "\nError301:No existen categorias"
 
error: .asciiz "\nError: "
return: .asciiz "\n"
catName: .asciiz "\nIngrese el nombre de una categoria: "
selCat: .asciiz "\nSe ha seleccionado la categoria:"
idObj: .asciiz "\nIngrese el ID del objeto a eliminar: "
objName: .asciiz "\nIngrese el nombre de un objeto: "
success: .asciiz "La operaci�n se realizo con exito\n\n"

.text
main:

loop:
    jal mostrarMenu #Llamo a la funcion que muestra el menu y pide que ingrese una opcion
    beq $v0, 1,A #En base a la opcion que eligio el usuario saltara a la etiqueta correspondiente
    beq $v0, 2,B
    beq $v0, 3,C
    beq $v0, 4,D
    beq $v0, 5,E
    beq $v0, 6,F
    beq $v0, 7,G
    beq $v0, 8,H
    beqz $v0,exit
    #Si elige una opcion fuera de las dadas saltara el mensaje de error 101
    la $a0,error
    li $v0, 4
    syscall
    j mostrarMenu

mostrarMenu:
    la $a0,menu
    li $v0,4
    syscall #Se muestra el menu
    li $v0,5
    syscall #Se pide al usuario que ingrese una opcion
    jr $ra #Se retorna a donde se llamo a la funcion
       
#--OPCIONES
A:
    la $a0,opcion1
    li $v0,4
    syscall
    jal newcaterogy
    
    j loop

B:
    la $a0,opcion2
    li $v0,4
    syscall
    
    jal sigCat
    j loop
C:
    la $a0,opcion3
    li $v0,4
    syscall
    
    jal categoriaAnterior
    
    j loop
D:
   la $a0,opcion4
   li $v0,4
   syscall
   
   jal listarCategorias
   
   j loop
E:
   la $a0,opcion5
   li $v0,4
   syscall
   
   jal main
   
   j loop
F:
   la $a0,opcion6
   li $v0,4
   syscall
   
   jal main
   j loop
G:
   la $a0,opcion7
   li $v0,4
   syscall
   
   jal main
   j loop
H:
   la $a0,opcion8
   li $v0,4
   syscall
   
   jal main
   
   j loop

      
sigCat:
   # Verificar si no hay categor�as (error 201)
   lw $t0, cclist
   beqz $t0, error_201

   # Verificar si hay solo una categor�a (error 202)
   lw $t1, 12($t0) # Siguiente categor�a
   beq $t0, $t1, error_202

   # Mostrar mensaje de �xito y avanzar a la siguiente categor�a
   la $a0, msjCatSig
   li $v0, 4
   syscall

   # Mostrar mensaje de la categor�a seleccionada
   lw $a0, cclist
   lw $a0, 4($a0)  # Direcci�n del nombre de la categor�a
   lw $a0, 0($a0)  # Contenido de la direcci�n
   li $v0, 4
   syscall

   j exit_sigCat

error_201:
   # Mostrar mensaje de error 201 y volver al men�
   la $a0, msjError201
   li $v0, 4
   syscall
   j exit_sigCat

error_202:
   # Mostrar mensaje de error 202 y volver al men�
   la $a0, msjError202
   li $v0, 4
   syscall
   j exit_sigCat

exit_sigCat:
   j loop


categoriaAnterior:
   # Verificar si no hay categor�as (error 201)
   lw $t0, cclist
   beqz $t0, error_201_ca

   # Verificar si hay solo una categor�a (error 202)
   lw $t1, 12($t0) # Siguiente categor�a
   beq $t0, $t1, error_202_ca

   # Mostrar mensaje de �xito y retroceder a la categor�a anterior
   la $a0, msjCatAnt
   li $v0, 4
   syscall

   # Mostrar mensaje de la categor�a seleccionada
   lw $a0, cclist
   lw $a0, 4($a0)  # Direcci�n del nombre de la categor�a
   lw $a0, 0($a0)  # Contenido de la direcci�n
   li $v0, 4
   syscall

   j exit_categoriaAnterior

error_201_ca:
   # Mostrar mensaje de error 201 y volver al men�
   la $a0, msjError201
   li $v0, 4
   syscall
   j exit_categoriaAnterior

error_202_ca:
   # Mostrar mensaje de error 202 y volver al men�
   la $a0, msjError202
   li $v0, 4
   syscall
   j exit_categoriaAnterior

exit_categoriaAnterior:
   j loop

listarCategorias:
   # Verificar si no hay categor�as (error 301)
   lw $t0, cclist
   beqz $t0, error_301_lc

   la $a0, catName
   jal cleanBuffer
   li $v0, 4
   syscall

   # Mostrar mensaje de �xito y lista de categor�as
   la $a0, success
   li $v0, 4
   syscall

   lw $t0, cclist
   lw $t1, 4($t0) # Direcci�n del primer nodo

print_categories:
   # Mostrar el nombre de la categor�a actual
   lw $a0, 0($t1) # Contenido de la direcci�n (nombre de la categor�a)
   li $v0, 4
   syscall

   # Mostrar un salto de l�nea
   li $v0, 4
   la $a0, return
   syscall

   # Mover al siguiente nodo
   lw $t1, 12($t1) # Direcci�n del siguiente nodo
   bnez $t1, print_categories

   j exit_listarCategorias

error_301_lc:
   # Mostrar mensaje de error 301 y volver al men�
   la $a0, msjError301
   li $v0, 4
   syscall
   j exit_listarCategorias

exit_listarCategorias:
   j loop


newcaterogy:
   addiu $sp, $sp, -4
   sw $ra, 4($sp)
   la $a0, catName # input category name
   jal getblock
   move $a2, $v0 # $a2 = *char to category name
   la $a0, cclist # $a0 = list
   li $a1, 0 # $a1 = NULL
   jal addnode
   lw $t0, wclist
   bnez $t0, newcategory_end
   sw $v0, wclist # update working list if was NULL
 
 # Entradas:
#   $a0: Direcci�n de la lista de nodos
#   $v0: ID del nodo a buscar
# Salidas:
#   $v0: Direcci�n del nodo encontrado (o 0 si no se encuentra)

    
 newcategory_end:
   li $v0, 0 # return success
   lw $ra, 4($sp)
   addiu $sp, $sp, 4
   jr $ra
 
addnode:
   addi $sp, $sp, -8
   sw $ra, 8($sp)
   sw $a0, 4($sp)
   jal smalloc
   sw $a1, 4($v0) # set node content
   sw $zero, 8($v0) # initialize node next pointer to NULL
   lw $a0, 4($sp)
   lw $t0, ($a0) # first node address
   beqz $t0, addnode_empty_list

 
 
addnode_to_end:
   lw $t1, ($t0) # last node address
 # update prev and next pointers of new node
   sw $t1, 0($v0)
   sw $t0, 12($v0)
 # update prev and first node to new node
   sw $v0, 12($t1)
   sw $v0, 0($t0)
   j addnode_exit
 
 
addnode_empty_list:
   sw $v0, ($a0)
   sw $v0, 0($v0)
   sw $v0, 12($v0)
 
 
addnode_exit:
   lw $ra, 8($sp)
   addi $sp, $sp, 8
   jr $ra
 
 # a0: node address to delete
 # a1: list address where node is deleted
 
delnode:
   addi $sp, $sp, -8
   sw $ra, 8($sp)
   sw $a0, 4($sp)
   lw $a0, 8($a0) # get block address
   jal sfree # free block
   lw $a0, 4($sp) # restore argument a0
   lw $t0, 12($a0) # get address to next node of a0
 
node:
   beq $a0, $t0, delnode_point_self
   lw $t1, 0($a0) # get address to prev node
   sw $t1, 0($t0)
   sw $t0, 12($t1)
   lw $t1, 0($a1) # get address to first node
 
again:
   bne $a0, $t1, delnode_exit
   sw $t0, ($a1) # list point to next node
   j delnode_exit
 
delnode_point_self:
   sw $zero, ($a1) # only one node
 
delnode_exit:
   jal sfree
   lw $ra, 8($sp)
   addi $sp, $sp, 8
   jr $ra
 
 getblock:
   addi $sp, $sp, -4
   sw $ra, 4($sp)
   li $v0, 4
   syscall
   jal smalloc
   move $a0, $v0
   li $a1, 16
   li $v0, 8
   syscall
   move $v0, $a0
   lw $ra, 4($sp)
   addi $sp, $sp, 4
   jr $ra

      
                  
smalloc:
   lw $t0, slist
   beqz $t0, sbrk
   move $v0, $t0
   lw $t0, 12($t0)
   sw $t0, slist
   jr $ra
sbrk:
   li $a0, 16 # node size fixed 4 words
   li $v0, 9
   syscall # return node address in v0
   jr $ra
sfree:
   lw $t0, slist
   sw $t0, 12($a0)
   sw $a0, slist # $a0 node address in unused list
   jr $ra
   
cleanBuffer:
   li $v0, 5
   syscall
   jr $ra


exit:
   li $v0, 10
   syscall
