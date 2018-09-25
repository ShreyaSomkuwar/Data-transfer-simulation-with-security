# Data-transfer-simulation-with-security

The given project simulates data transfer within a network amoung individual nodes with encryption. 

## Requirements
- Scilab
- NARVAL module 

## Working of the code
Initially a graph with 7 nodes is made. The routing table is found out for the given table using Dijkshtra's algorithm. The network matrix for the network is build. Initiating the data tansfer, nodes with packets are identified. From the identified nodes, packets are sent to all the remaining nodes. For each transfer of packet, AES encyption is performed for security.
