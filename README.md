# Iterative Merge Sort Algorithm Implemented in x86-64 Assembly Language
This small project is a simple implementation of the traditional merge sort algorithm (iterative version) in x86-64 assembly. In the iterative version, the algorithm utilizes a bottom-up approach, starting from 1 element-sized arrays (automatically sorted) up to power of 2 element-sized arrays. The implementation was mostly based on GeeksForGeek's iterative merge sort implementation in C, which can be found on the link below:

<i>Algorithm Reference</i>: https://www.geeksforgeeks.org/iterative-merge-sort/

<br>
The following <b>README</b> file contains brief step-by-step instructions on how to change the parameters of the function and execute the .exe file based on the assembly file.

<br>
<b>Setup</b>: Open the <b><i>merge_sort.asm</i></b> file in any coding or assembly editor software.
<br><br>
<b>Changing of Parameters</b>: In the <i>section .data</i> portion of the <b><i>merge_sort.asm</i></b> assembly file, simply modify the contents of the <i>numArr</i> integer array. This array only accepts signed integer values from the range <i>-2147483648 to 2147483647</i>. Afterwards, change the value of the <i>arraySize</i> variable found in the same <i>section .data</i> portion based on the final total number of elements in the <i>numArr</i> integer array.
<br><br>  
<b>Save the file as .exe</b>: After saving the changes in the assembly file, simply save the file as <i>.exe</i> and run the <i>.exe</i> file in your terminal. Make sure that you are in the same directory as that of the assembly <i>.exe</i> file.

<br><br>

For further information, inquiries, or concerns, please do not hesitate to contact the repository owner.


