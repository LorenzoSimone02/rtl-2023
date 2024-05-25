# Prova finale di Reti Logiche 2023-2024

**Studente**: Lorenzo Simone

**Docente**: Gianluca Palermo

**Valutazione progetto**: 30/30


## Specifica del progetto

<p align="justify"> L'obiettivo della prova finale di Reti Logiche è quello di implementare, attraverso l'utilizzo del linguaggio VHDL, un componente HW sincrono che, agendo sul fronte di salita del segnale di clock, fosse in grado di interfacciarsi con una memoria. 
Il componente  doveva essere in grado di:

- Leggere, contestualmente all'attivazione di un segnale di avvio _i_start=1_, un messaggio composto da una sequenza di K parole W, con valori compresi tra 0 e 255.
La sequenza di K parole è memorizzata a partire da un indirizzo di memoria specificato (ADD), ogni 2 byte (ADD, ADD+2, ADD+4, ..., ADD+2*(K-1)).

- Completare la sequenza sostituendo le parole con valore 0 con l'ultimo valore non 0 letto e inserendo un valore di "credibilità" C nel byte mancante per ogni valore della sequenza.

Il valore di credibilità C, inizializzato a 0, è 31 quando il valore della parola W è diverso da 0 e viene decrementato di 1 rispetto al valore precedente ogni volta che si incontra uno zero in W. Il valore C è sempre maggiore o uguale a 0 e si reinizializza a 31 ogni volta che si incontra un valore W diverso da zero. </p>

## Esempio di funzionamento
![Esempio](https://github.com/LorenzoSimone02/rtl-2023/assets/15893018/421853a2-0083-4db6-95d9-177659c26e64)


