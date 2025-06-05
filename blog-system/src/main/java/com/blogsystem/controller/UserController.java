package com.blogsystem.controller;

import com.blogsystem.entity.User;
import com.blogsystem.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class UserController {

    private final UserService userService;

    // 用户注册
    @PostMapping("/register")
    public ResponseEntity<Object> registerUser(@RequestBody Map<String, String> request) {
        try {
            String account = request.get("account");
            String username = request.get("username");
            String email = request.get("email");
            String password = request.get("password");
            String fullName = request.get("fullName"); // 可选字段

            // 如果没有提供account，使用username作为account
            if (account == null || account.trim().isEmpty()) {
                account = username;
            }

            // email字段为可选，如果为空则设置为null
            if (email != null && email.trim().isEmpty()) {
                email = null;
            }

            if (fullName == null || fullName.trim().isEmpty()) {
                fullName = username; // 如果没有提供fullName，使用username作为默认值
            }

            User user = userService.registerUser(account, username, email, password, fullName);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "注册成功");
            response.put("user", user);

            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());

            return ResponseEntity.badRequest().body(response);
        }
    }

    // 用户登录
    @PostMapping("/login")
    public ResponseEntity<Object> loginUser(@RequestBody Map<String, String> request) {
        String account = request.get("account");
        String password = request.get("password");

        Optional<User> userOpt = userService.authenticate(account, password);

        Map<String, Object> response = new HashMap<>();
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // 生成简单的token（实际项目中应使用JWT）
            String token = "token_" + user.getId() + "_" + System.currentTimeMillis();

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", user);

            response.put("success", true);
            response.put("message", "登录成功");
            response.put("data", data);
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "账号或密码错误");
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 获取用户信息
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        Optional<User> user = userService.findById(id);
        return user.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 更新用户信息
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        Optional<User> existingUser = userService.findById(id);
        if (existingUser.isPresent()) {
            user.setId(id);
            // 保持原有的密码和创建时间
            user.setPassword(existingUser.get().getPassword());
            user.setCreatedAt(existingUser.get().getCreatedAt());

            User updatedUser = userService.updateUser(user);
            return ResponseEntity.ok(updatedUser);
        }
        return ResponseEntity.notFound().build();
    }

    // 修改密码
    @PutMapping("/{id}/password")
    public ResponseEntity<Object> changePassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        String oldPassword = request.get("oldPassword");
        String newPassword = request.get("newPassword");

        boolean success = userService.changePassword(id, oldPassword, newPassword);

        Map<String, Object> response = new HashMap<>();
        if (success) {
            response.put("success", true);
            response.put("message", "密码修改成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "原密码错误");
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 删除用户
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        Optional<User> user = userService.findById(id);
        if (user.isPresent()) {
            userService.deleteUser(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    // 获取所有用户（管理员功能）
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    // 检查用户名是否存在
    @GetMapping("/check-username/{username}")
    public ResponseEntity<Object> checkUsername(@PathVariable String username) {
        boolean exists = userService.existsByUsername(username);
        Map<String, Object> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 检查邮箱是否存在
    @GetMapping("/check-email/{email}")
    public ResponseEntity<Object> checkEmail(@PathVariable String email) {
        boolean exists = userService.existsByEmail(email);
        Map<String, Object> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 设置管理员权限
    @PutMapping("/{id}/admin")
    public ResponseEntity<User> setAdminRole(
            @PathVariable Long id,
            @RequestBody Map<String, Boolean> request) {
        Boolean isAdmin = request.get("isAdmin");
        User user = userService.setAdminRole(id, isAdmin);
        if (user != null) {
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.notFound().build();
    }

    // 根据用户名获取用户
    @GetMapping("/username/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        Optional<User> user = userService.findByUsername(username);
        return user.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 获取当前用户资料（模拟接口，实际应该从token中获取用户信息）
    @GetMapping("/profile")
    public ResponseEntity<Object> getCurrentUserProfile() {
        // 这里应该从JWT token或session中获取当前用户信息
        // 为了演示，我们返回一个模拟的用户信息
        Map<String, Object> profile = new HashMap<>();
        profile.put("username", "testuser");
        profile.put("email", "");
        profile.put("role", "user");
        profile.put("createdAt", "2024-01-01T00:00:00");

        return ResponseEntity.ok(profile);
    }

    // 更新当前用户资料
    @PutMapping("/profile")
    public ResponseEntity<Object> updateCurrentUserProfile(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");

            // 这里应该从JWT token或session中获取当前用户ID
            // 为了演示，我们假设用户ID为1
            Long currentUserId = 1L;

            // 验证邮箱格式
            if (email != null && !email.trim().isEmpty()) {
                if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("message", "邮箱格式不正确");
                    return ResponseEntity.badRequest().body(response);
                }
            }

            // 更新用户邮箱
            Optional<User> userOpt = userService.findById(currentUserId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                user.setEmail(email != null && !email.trim().isEmpty() ? email : null);
                userService.updateUser(user);

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "个人资料更新成功");
                response.put("user", user);

                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "用户不存在");
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "更新失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}