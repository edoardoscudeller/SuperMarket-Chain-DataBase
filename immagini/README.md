# Cartella `immagini/`

Questa cartella è destinata a tutte le immagini da includere nel documento.

## Formati supportati

- `.pdf` — raccomandato per grafici vettoriali
- `.png` — raccomandato per screenshot e immagini raster
- `.jpg` / `.jpeg` — per fotografie
- `.eps` — per immagini vettoriali legacy

## Come includere un'immagine nel main

```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{immagini/nome-immagine.png}
    \caption{Descrizione dell'immagine.}
    \label{fig:nome-label}
\end{figure}
```

Ricordare di aggiornare il percorso con il nome file corretto.
