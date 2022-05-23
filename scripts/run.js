const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();

    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);

    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
      );
      console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
      );
    

    let waveCount;
    waveCount = await waveContract.getTotalWaves();

    let waveTxn = await waveContract.wave('Hi! I am the first one waving!');
    await waveTxn.wait();

    waveTxn = await waveContract.wave('Tis my second wave!');
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.connect(randomPerson).wave('Looks like I\'m late!');
    await waveTxn.wait();

    waveTxn = await waveContract.connect(randomPerson).wave('Looks like I\'m late!');
    await waveTxn.wait();
    
    waveTxn = await waveContract.connect(randomPerson).wave('Looks like I\'m late!');
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();

    console.log();

    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
      );
      console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
      );
    

    // let wavers = await waveContract.getTopWavers();
    // console.log(
    //     `The wavers gang is ${wavers.length} members strong!!!`,
    //     `\nSome top wavers: `
    // );
    // console.log(wavers);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();  