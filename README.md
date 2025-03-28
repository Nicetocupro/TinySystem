# TinySystem - 一个微型操作系统的探索之旅 🚀

> "每个程序员心中都有一个操作系统梦" —— 这是我在大学时读到的一句话。如今，我终于鼓起勇气，开始了这段充满挑战又令人兴奋的旅程。

## 🌟 项目简介

这是一个从零开始的微型操作系统项目，参考了[这篇博客](https://blog.csdn.net/vivo01/article/details/125126833)的实现思路。虽然原博客是在Ubuntu 16.04虚拟机环境下调试的，但我勇敢地尝试了真机调试（虽然遇到了些挫折😅），最终在QEMU虚拟环境中取得了成功！

## 📦 文件结构

```
TinySystem/
├── Makefile           # 自动化编译的好帮手
├── tiny_sys.lds       # 内核的内存布局设计师
├── tiny_system_entry.s # 系统的"第一句话"(汇编入口)
└── main.c             # 内核的主逻辑大脑
```

## 🛠️ 准备工作

### 安装依赖（让我们先把工具准备齐全）

```bash
# 基础编译工具
sudo apt install build-essential nasm

# QEMU虚拟环境
sudo apt install qemu-system-x86

# ISO制作工具
sudo apt install xorriso grub-efi grub-pc-bin mtools
```

> 小贴士：如果遇到权限问题，记得在命令前加上`sudo`哦~

## 🖥️ QEMU调试指南

QEMU是我们的安全沙盒，在这里可以大胆尝试而不用担心搞坏系统！

```bash
# 1. 创建ISO目录结构
mkdir -p iso/boot/grub

# 2. 把我们的"宝贝"内核放进去
cp TinySystem.elf iso/boot/

# 3. 告诉GRUB怎么启动我们的系统
cat > iso/boot/grub/grub.cfg <<EOF
menuentry "TinySystem" {
    multiboot2 /boot/TinySystem.elf
    boot
}
EOF

# 4. 制作可启动ISO（就像烤制一张系统光盘💿）
grub-mkrescue -o TinySystem.iso iso/

# 5. 启动QEMU虚拟机
qemu-system-x86_64 -cdrom TinySystem.iso -serial stdio
```

**预期效果**：你应该能看到屏幕上出现可爱的"EK"两个字母！这是我们的内核在向你打招呼呢~ 👋

![QEMU运行截图](https://github.com/user-attachments/assets/82f159d3-73f7-4431-880f-5038a0931aa3)

## 💻 真机调试历险记

> 警告：这部分是我的"血泪史"，虽然最终没能成功，但收获了很多经验！

### 我的装备
- 联想Y9000X 2022款
- 双系统：Windows 11 + Ubuntu 22.04

### 闯关步骤

1. **关闭安全启动** 🔒
   - 重启进入BIOS（疯狂按F2）
   - 找到"Secure Boot"选项 → 禁用
   - 保存设置并退出

   > 这一步就像拿到系统大门的钥匙！

2. **配置GRUB** 🛠️
   编辑`/boot/grub/grub.cfg`，在末尾添加：

   ```grub
   menuentry 'TinySystem' {
       insmod part_gpt
       insmod ext2
       search --no-floppy --fs-uuid --set=root 你的boot分区UUID
       multiboot2 /boot/TinySystem.elf
       boot
   }
   ```

   > 小技巧：用`lsblk -f`查看分区UUID

3. **重启选择TinySystem** 🔄
   - 满怀期待地等待...
   - 结果...黑屏了 😭

### 经验总结

虽然真机调试失败了，但我学到了：
1. 现代笔记本的硬件比QEMU复杂得多
2. VGA初始化可能需要更细致的处理
3. 安全启动确实是个"大魔王" 🐉

## 💡 给勇敢的后来者

如果你想尝试真机调试，这里有些建议：
1. 先用老旧电脑尝试（新硬件太复杂）
2. 添加串口调试输出（救命的printf！）
3. 准备一个Live USB救急盘（血的教训）

## 🤝 加入我们

虽然这个项目还很稚嫩，但每个伟大的系统都从小小的"Hello World"开始。如果你也对这个领域感兴趣：
- 欢迎Fork本项目
- 提交Issue分享你的想法
- 一起解决真机调试的难题！

> "不是因为事情困难我们不敢做，而是因为我们不敢做，事情才变得困难。" —— 塞涅卡

让我们一起在操作系统的世界里冒险吧！ 🚀
真机
