# Digital Voice Communication System Using PCM, Manchester Coding, QPSK, and TDM

A MATLAB demonstration of digital communication stages, developed for **ECE 3207: Communication Engineering** at **Rajshahi University of Engineering & Technology (RUET)** by **Puja Roy Dipa**.

The project explores signal sampling, 8-bit pulse-code modulation (PCM), Manchester encoding, quadrature phase-shift keying (QPSK), time-division multiplexing (TDM), and signal reconstruction. It includes the original academic report, its simulation figures, and a runnable transcription of the MATLAB code.

## Repository contents

| File | Description |
| --- | --- |
| [`digital_voice_communication.m`](digital_voice_communication.m) | Complete simulation in one MATLAB script, transcribed from report pages 4-5. |
| [`figures.pdf`](figures.pdf) | All six original simulation plots, collected from report pages 6-8 into one PDF. |
| [`report.pdf`](report.pdf) | Original, unmodified 10-page assignment report. |
| `README.md` | Project overview, setup, workflow, and implementation notes. |

## Simulation workflow

```text
Synthetic input tone -> Sampling and 8-bit PCM -> Manchester encoding
    -> QPSK modulation -> Two-channel TDM -> Demultiplexing
    -> QPSK demodulation -> Manchester decoding -> Sample reconstruction
```

## Requirements and usage

- MATLAB with **Communications Toolbox** (`de2bi`, `bi2de`, `pskmod`, and `pskdemod`).

Download or clone the repository, open its directory in MATLAB, and run:

```matlab
digital_voice_communication
```

The script clears the workspace and opens six figures: the input signal, quantized signal, Manchester waveform, QPSK in-phase component, TDM waveform, and reconstructed/input comparison. The bundled figures are the original report outputs; the script does not overwrite them.

## Parameters in the supplied code

| Parameter | Value |
| --- | --- |
| Input | 1 kHz sinusoid, amplitude 0.7 |
| Sampling frequency | 4 kHz |
| Duration | 10 ms (41 samples, including both endpoints) |
| PCM resolution | 8 bits, 256 levels |
| Nominal PCM bit rate | 32 kb/s |
| Manchester mapping | `0 -> [0 1]`, `1 -> [1 0]` |
| Modulation | QPSK, Gray ordering, pi/4 phase offset |
| TDM | Two duplicated streams |
| Noise model | No noise added in the supplied code |

## Scope and implementation notes

This repository preserves the assignment implementation, with section headings and startup housekeeping added for usability. It is an educational stage-by-stage demonstration with known limitations:

- **Report/code differences:** the report summary describes a 4.2 kHz input, 24 kHz sampling, ten channels, synchronization bits, AWGN at 10 dB, and BER evaluation. Those features are absent from the embedded code. The parameter table above describes the actual script.
- **Voice bandwidth:** the input is a synthetic 1 kHz tone, not recorded speech. A 4 kHz sampling rate supports this tone but cannot sample an arbitrary 4 kHz voice band without aliasing. Such a band requires at least 8 kHz sampling, with practical margin and anti-alias filtering.
- **Complex QPSK information:** the TDM stage retains only `real(qpskMod)`, discarding the quadrature component. This loses phase information and prevents reliable QPSK recovery.
- **Bit ordering:** modulation uses `bi2de` with its default ordering, while demodulation serializes with `left-msb`. These conventions are inconsistent.
- **Manchester constraints:** grouping each Manchester pair into a QPSK symbol uses only two of the four possible symbol labels. The code therefore does not demonstrate full QPSK payload efficiency.
- **Reception:** invalid Manchester pairs are decoded as zero; clock recovery, frame synchronization, pulse shaping, and receiver filtering are not modeled.
- **Results:** the reconstructed waveform in the original figures visibly differs from the input. The report's approximate 90% match is not established by a metric in the supplied script.

These limitations are documented so the archived assignment can be studied and reproduced without overstating its performance.

## Possible extensions

Preserve both I/Q components, align bit ordering, validate Manchester symbols, use independent TDM channels, and introduce an AWGN channel with measured BER. Further work could add recorded speech, practical sampling and filtering, synchronization, and forward error correction.

## Academic context

- **Author:** [Puja Roy Dipa](https://github.com/puja-roy-dipa)
- **Institution:** Rajshahi University of Engineering & Technology
- **Course:** ECE 3207 - Communication Engineering
- **Original submission:** 18 June 2025

## References

References reproduced from the original report:

1. B. P. Lathi and Zhi Ding, *Modern Digital and Analog Communication Systems*, Oxford University Press, 4th edition, 2010.
2. Simon Haykin, *Communication Systems*, Wiley, 5th edition, 2009.
