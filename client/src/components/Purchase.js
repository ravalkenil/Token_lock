import React, { useState,useEffect } from "react";
const { ethers } = require("ethers");

const Purchase = ({state})=>{
    const [re_token,settoken] = useState(0);
    const [cla_token,setclaim] = useState(0);
    const [lock_token,setlock_token] = useState(0);

    const Remaining = async (e) => {
        const { contract } = state;
        const remaining_token = await contract.balanceOf(contract.address);
        const min = Number(remaining_token);
        settoken(min);
    }

    const claimed_token = async (e) => {
        const {contract} = state;
        const claimed_to = await contract.check_claimed_token();
        console.log(claimed_to.value);
        const claimed = Number(claimed_to);
        console.log(claimed)
        setclaim(claimed);
    }

    const Lock_token = async (e) => {
        e.preventDefault();
        const {contract} = state;
        const { ethereum } = window;
        const account = await ethereum.request({
            method: 'wallet_watchAsset',
            params: {
              type: 'ERC20',
              options: {
                address: contract.address,
                symbol: 'Bi',
                decimals: 2,
                image: 'https://foo.io/token-image.svg',
              },
            },
          })

        const claim_lock_token = contract.Claim_Locktoken(lock_token);
    };

    const Connect_wallet = async () => {
        const { ethereum } = window;
        const { contract } = state;

        if(!ethereum.isConnected()){
            const account = await ethereum.request({method:"eth_requestAccounts"});
            const provider = new ethers.providers.Web3Provider(ethereum);
        }else{
            alert("already connected switch account click metamask");
        }
    }

    return(
    <>
    <div className="d1" >
        <h2>Claimed Lock-token</h2>
        <div className="d2 d-flex flex-column justify-content-center align-items-center">
            <h2 style={{color: "black",fontSize:"40px"}}>{re_token}</h2>
            <button type="submit" onClick={()=>Remaining()} className="btn btn-info w-50 my-4">Remaining-Token</button>
            <h2 style={{color: "black",fontSize:"40px"}}>{cla_token}</h2>
            <button type="submit" onClick={()=>claimed_token()} className="btn btn-success w-50 my-4">Claimed-Token</button>
        </div>
    </div>
    <div className="d3 d-flex flex-column justify-content-center align-items-center">
        <form className="f1" onSubmit={Lock_token}>
            <input className="input1" id="name" type="number" value={lock_token} placeholder="Enter Token Value" onChange={(e)=>setlock_token(e.target.value)}></input><br></br><br></br>
            <button type="submit" className="btn btn-primary w-50 my-4">Buy-Token</button>
        </form>
        <button type="submit" onClick={()=>Connect_wallet()} id="connect-button" className="btn btn-danger w-50 my-4">Connect-wallet</button>
    </div>
    </>
    );
}

export default Purchase;