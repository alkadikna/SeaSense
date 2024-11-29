//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package flora.simulations;

import inet.applications.udpapp.UdpBasicApp;
import inet.node.inet.Router;
import inet.node.internetcloud.InternetCloud;
import flora.LoRaPhy.LoRaMedium;
import flora.LoraNode.LoRaNode;
import flora.LoraNode.LoRaGW;
import inet.node.inet.StandardHost;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.Eth1G;

@license(LGPL);
network SeaSense
{
    parameters:
        int numberOfNodes = default(5);  // Jumlah node
        int numberOfGateways = default(1);  // Jumlah gateway
        int networkSizeX = default(10000);  // Lebar jaringan dalam meter
        int networkSizeY = default(4000);  // Tinggi jaringan dalam meter
        @display("bgb=10000,10000");
    submodules:
        loRaNodes[numberOfNodes]: LoRaNode {
            @display("p=5000,379");
        }
        loRaGW[numberOfGateways]: LoRaGW {
            @display("p=5000,313;is=s");
        }
        LoRaMedium: LoRaMedium {
            @display("p=5271,154");
        }
        networkServer: StandardHost {
            parameters:
                @display("p=4511,119");
        }
        configurator: Ipv4NetworkConfigurator {
            parameters:
                assignDisjunctSubnetAddresses = false;
                @display("p=5190,105");
        }
        internetCloud: InternetCloud {
            @display("p=5000,119");
        }
        gwRouter[numberOfGateways]: Router {
            @display("p=5000,209");
        }
        nsRouter: Router {
            @display("p=4750,119");
        }
    connections:
        networkServer.ethg++ <--> Eth1G <--> nsRouter.ethg++;
        nsRouter.pppg++ <--> Eth1G <--> internetCloud.pppg++;
        for i=0..numberOfGateways-1 {
            internetCloud.pppg++ <--> Eth1G <--> gwRouter[i].pppg++;
            gwRouter[i].ethg++ <--> Eth1G <--> loRaGW[i].ethg++;
        }
}