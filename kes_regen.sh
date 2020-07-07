echo "###########################################################
#                                                               #
#  This script was written by the pool opererator KAKE1         #
#                                                               #
#  This script is not an official IOHK approved script 	 		#
#  and therefore should not be treated as such. It is 			#
#  created to assist in an easy and automated way to 			#
#  renew the KES and regenerate an Operational Certificate.    	#
#                                                 				#                                                             
#  																#
#################################################################"

cd ~/shelley/cardano-my-node

#Find the current tip
tip=`cardano-cli shelley query tip --testnet-magic 42 | grep -oP 'SlotNo = \K\d+'`

#Find the KES perioed from the genesis.json file
cat ~/shelley/cardano-my-node/shelley_testnet-genesis.json | grep KESPeriod >> KES.txt

#Removes the , after the KES period
truncate -s-2 KES.txt

#Set KES variable to that of the KES period
kes=`awk '{print $2}' KES.txt`

rm KES.txt

echo "The current tip is ' $tip ' and the KES vale is " $kes

read -p "Press enter if the above outputs correctly: "

#Calcualted KES period
kes_period=`expr $tip / $kes` 

echo $kes_period

#Generate the Node Operational certificate
cardano-cli shelley node issue-op-cert \
    --kes-verification-key-file kes.vkey \
    --cold-signing-key-file ~/shelley/cardano-my-node/cold-keys/cold.skey \
    --operational-certificate-issue-counter ~/shelley/cardano-my-node/cold-keys/cold.counter \
    --kes-period $kes_period \
    --out-file opcert

echo "Node operational cert (opcert) successfully created."
echo -en '\n'
