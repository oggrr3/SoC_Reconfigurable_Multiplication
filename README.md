# 1. Struct of reconfigurable multiplication

![alt text](./images/image.png)

`Choose mode config`

![mode](./images/mode.png)

## 1.1. Register Map with AXI LITE interface
![register map](./images/register_map.png)


# 2. SoC 
![alt text](./images/soc.png)
## 2.1. Generate Block Design
![generate block design](./images/generate_block_design.png)
- And then Generate Bistream. 
- And then File -> Export -> Export Hardware with bistream.
- And then Tools -> Launch Vitis IDE.

## 2.2. Creat Platform project
- Note: After regenerate bistream in Vivado, let right click on Platform project and choose Update Hardware Specification
![update hardware](./images/Update_Hardware.png)

## 2.3. Creat Application project
- Built project.

# 3. Run code
## 3.1. On Vivado
- Open Hardware Manager -> Open target -> Program Device.

## 3.2. On Vitis
- Right click on Application Project -> Run As -> Launch Hardware
- And then click Debug window.
![vitis](./images/vitis.png)

- Connect Vitis Serial Terminal. NOTE: Baud Rate must equals UART_LITE in block SoC (Vivado).
![run vitis](./images/run_vitis.png)

