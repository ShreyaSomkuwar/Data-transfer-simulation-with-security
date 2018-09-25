//NETWORK PROJECT
//IMPLEMENT NETWOK TOPOLOGY WITH DATA TRANSFER INCLUDING SECURITY STANDARDS
//      BY SHREYA SOMKUWAR 

name='TOPOLOGY';// graph name
n=7;//graph parameters
tail=[1 1 1 2 2 3 3 4 4 4 5 6];
head=[2 3 4 4 5 4 6 5 6 7 7 7];
node_x=[100 275 275 500 750 750 900];
node_y=[500 200 800 500 200 800 500];
[g]=NL_G_MakeGraph(name,n,tail,head,node_x,node_y)//application of NL_G_MakeGraph
windowIndex=1;
f=NL_G_ShowGraphN(g,windowIndex);

[rt]=NL_R_DijkstraRT(g)//application of NL_R_DijkstraRT

//application of presence table
[l c]=size(rt);
[pp]=NL_R_RTPathPresence(rt,l);

//implementation of data transfer 
n=7;
bs=15;//constant buffer size
[nd,nf]=NL_F_RandIntNiNj(n);//generation of connection extreme nodes
L=1000;//network square area side
t=1;//current time
[probroute]=NL_I_RouteManagerInit(rt,rt,rt,rt,rt,pp,n,L);//initialization of the route manager

//Generation network matrix
network=NL_I_NetworkMatrixInit(n,bs);//initialization of the reception network matrix 
networks=NL_I_NetworkMatrixInit(n,bs);//initialization of the emission network matrix
tpmax=n*bs;//maximal quantity of packets simultaneously supported by each network matrix 
rp=NL_I_PacketManagerInit(tpmax);//initialization of the packet manager
cpmax=10;//maximal quantity of packets per connection
ct=1;//connection type selection index: creation of Tcp connections
swmin=1;
rtmin=1;
rtmax=50;
pr=0.90;//probability threshold
[swi,rti]=NL_I_TCPNetworkInit(n,swmin,rtmin);//initialization of the TCP parameters for each node
[networks,rp]=NL_I_ConnectionManager(nd,n,bs,cpmax,networks,rp,ct,pr);//generation of connections
[swi,rti,network,networks,rp]=NL_I_Emission2Reception(swi,rti,rtmax,network,networks,n,bs,rp,t,probroute);//emission of packets on the reception network

//selection of source nodes
ind=find(network(:,$) <> 0);//TCP packets present on the network
disp(network,"Network matrix before any transmission:");
disp(ind,"Nodes in which packets are available:");
[ind_r,ind_size]=size(ind);
w=2;

//select destination nodes
for b=1:ind_size
    i=ind(b);//selection of the first one
    p=network(i,1);//first TCP packet
    //j=7;//Destination node
    disp(i,"Source node:");
    disp(network(i,:),':',i,'Network buffer of source node,');//buffer of the node i
    mod=33;//modulus
    pu=3;//public exponent
    pr=7;//private exponent
    disp(p,'Original packet:');
    p1=p+15;
    
    //encryption of data
    [en]=NL_S_RSAEncryption(mod,pu,p1);//application of NL_S_RSAEncryption
    disp(en,'After encryption:');
    for j=1:7
        if(j~=i) then
            disp(j,"Destination node:");
            [path]=NL_R_DijkstraNiNj(g,i,j);//application of NL_R_DijkstraNiNj
            cack=0.8;
            closs=0.8;
            [n1,n2]=size(path);
            disp(path,'Path to be followed by the packet:');
            i1=i;
            for k=1:(n2-1)
                [j,ack]=NL_I_PathNextNode(i1,path);
                if(j==path(n2)) then
                    //decryption of data
                    [de]=NL_S_RSADecryption(mod,pr,en)//application of NL_S_RSADecryption
                    de=de-15;
                    disp(network(j,:),'before transmission:',j,'Network buffer of ');
                    [network,rp,swi,rti]=NL_I_PacketTCPIntraNet(j,de,network,rp,t,swi,rti,rtmax);
                    disp(network(j,:),'after transmission:',j,'Network buffer of ');
                    disp(en,'Recieved Packet:')
                    disp(de,'After decryption:');
                else
                    disp(network(j,:),'before transmission:',j,'Network buffer of ');
                    [network,rp,swi,rti]=NL_I_PacketTCPIntraNet(j,en,network,rp,t,swi,rti,rtmax);
                    disp(network(j,:),'after transmission:',j,'Network buffer of ');
                end
                i1=j;
            end
            [g] = NL_G_HighlightPath(path,g,2,3,3,10,w);
            w=w+1;
        end
    end
end




 
 

