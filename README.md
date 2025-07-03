This app is built upon ARKit developed by Apple. You will need Macbook as developing tool and test the app on your iPhone.

## How to run this VIO on your iPhone
1. Install IDE **Xcode** or **Xcode-beta** from the website.
    ```
    https://developer.apple.com/xcode/
    ```

2. Clone this repo and open it in Xcode/Xcode-beta.
    ```
    git clone git@github.com:YuanzhuZhan/VIO-iPhone.git -b udp
    '''

3. Clone another repo for relaying VIO data from iPhone as rostopic.
    ```
    git clone git@github.com:YuanzhuZhan/vio-receiver.git
    ```

4. In VIO-iPhone/ContentView.swift, adjust the **host** and **port** according to your local network.
    ```
    connection = NWConnection(host:"192.168.1.25", port: 9000, using: .udp)
    ```

5. Enable the Developer Mode on your iPhone first, then build the VIO-iPhone project and download it to your iPhone. Then, you can launch this app on your phone.

6. At the same time, run the rosnode in vio-receiver on your Linux computer to monitor the odometry data.
```
rosrun vio_receiver vio_udp_receiver.py
```

