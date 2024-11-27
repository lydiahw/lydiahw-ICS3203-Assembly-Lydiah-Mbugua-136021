# lydiahw-ICS3203-Assembly-Lydiah-Mbugua-136021
## Programs Overview

### Task 1: Control Flow and Conditional Logic
- **Purpose**: This program prompts the user for a number and classifies it as “POSITIVE,” “NEGATIVE,” or “ZERO.” It utilizes both conditional and unconditional jumps to manage program flow.
- **Insights**: The use of conditional jumps (e.g., `JGE`, `JL`) allows for branching based on the number's value, while unconditional jumps (e.g., `JMP`) direct the flow to specific sections of the code for output.
- **Challenge**: Deciding which jumps to use for every scenario.

### Task 2: Array Manipulation with Looping and Reversal
- **Purpose**: This program accepts an array of five integers from the user, reverses the array in place, and outputs the reversed array.
- **Insights**: By employing two pointers and a loop, the program effectively swapped elements in place. Careful management of loop counters was essential to avoid overwriting data.
- **Challenge**: Implementing the reversal of the array in a way that ensured no loss of data and navigating a way to do so without additional memory.

### Task 3: Modular Program with Subroutines for Factorial Calculation
- **Purpose**: This program computes the factorial of a user-provided number using a subroutine to perform the calculation. It demonstrates the use of the stack to preserve register values.
- **Insights**: The program saves registers on the stack before entering the subroutine and restores them afterward, ensuring that the main program remains unaffected by changes made during the factorial calculation.
- **Challenges**: Managing the stack and ensuring that registers were preserved and restored correctly.

### Task 4: Data Monitoring and Control Using Port-Based Simulation
- **Purpose**: This program simulates reading a sensor value from a memory location and performs actions based on the input, such as turning on a motor or triggering an alarm.
- **Insights**: The program's logic for determining actions based on sensor input involved careful comparisons and bit manipulation. Understanding how to interact with memory locations was essential for simulating the motor and alarm states.
- **Challenges**:Simulating hardware interactions required a solid understanding of memory manipulation and control logic.

## Compiling and Running the Code

To compile and run the assembly programs, follow these steps:

1. **NASM and GCC**: Ensure you have NASM and GCC installed.

2. **Build**: To build task, CTRL+SHIFT+B. This builds the task into an executable file.

3. **Run the Programs**:Open the VS Code terminal and type the name of the executable file as follows: ./task_1.exe.(Change according to relevant task).
   

