import Purchase from "./components/Purchase";
import { useState,useEffect } from "react";
import abi from "../src/contracts/Purchase.json"
import "./App.css";
const { ethers } = require("ethers");

const App = () => {
  const [state, setState] = useState({ provider: null, signer: null, contract: null});
  useEffect(() => {
    const connectwallet = async () => {
        const Contract_address = "0x14b3A10dC534C29EF3f132930ADdeb13C28F0eb7";
        const Abi = abi.abi;
        const { ethereum } = window;
        const account = await ethereum.request({method:"eth_requestAccounts"});
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(Contract_address, Abi, signer);
        setState({provider,signer,contract});  

    };
    connectwallet();    
},[]);
  return (

      <div id="App" >
        <div className="container" style={{border:"2px"}}>
          {<Purchase state={state} />}
        </div>
      </div>

  );
}

export default App;