   ### D flip flop
   |               **clk**                      | **d** | **q(n)** | **q(n+1)** | **Comments** |
   |                   :-:                      | :-:   | :-:      | :-:        | :--          |
   | ![rising](images/eq_uparrow.png)           | 0     | 0        |     0      |    RESET     |
   | ![rising](images/eq_uparrow.png)           | 0     | 1        |     0      |    RESET     |
   | ![rising](images/eq_uparrow.png)           | 1     | 0        |     1      |     SET      |
   | ![rising](images/eq_uparrow.png)           | 1     | 1        |     1      |     SET      |

   ### J-K flip flop
   |              **clk**             | **j** | **k** | **q(n)** | **q(n+1)** | **Comments** |
   |                :-:               | :-:   |  :-:  |    :-:   |     :-:    |      :--     |
   | ![rising](images/eq_uparrow.png) | 0     | 0     | 0        | 0          | No change    |
   | ![rising](images/eq_uparrow.png) | 0     | 0     | 1        | 1          | No change    |
   | ![rising](images/eq_uparrow.png) | 0     | 1     | 0        | 0          | Reset        |
   | ![rising](images/eq_uparrow.png) | 0     | 1     | 1        | 0          | Reset        |
   | ![rising](images/eq_uparrow.png) | 1     | 0     | 0        | 1          | Set          |
   | ![rising](images/eq_uparrow.png) | 1     | 0     | 1        | 1          | Set          |
   | ![rising](images/eq_uparrow.png) | 1     | 1     | 0        | 1          | Toggle       |
   | ![rising](images/eq_uparrow.png) | 1     | 1     | 1        | 0          | Toggle       |

   ### T flip flop
   |              **clk**             | **t** | **q(n)** | **q(n+1)** | **Comments** |
   |                :-:               | :-:   | :-:      | :-:        | :--          |
   | ![rising](images/eq_uparrow.png) | 0     | 0        | 0          |  Hold state  |
   | ![rising](images/eq_uparrow.png) | 0     | 1        | 1          |  Hold state  |
   | ![rising](images/eq_uparrow.png) | 1     | 0        | 1          |    Toggle    |
   | ![rising](images/eq_uparrow.png) | 1     | 1        | 0          |    Toggle    |
