import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'user_database.g.dart'; // 生成的文件

@DriftAccessor(tables: [Users])
class UserDatabase extends DatabaseAccessor<AppDatabase> with _$UserDatabaseMixin {
  UserDatabase(AppDatabase db) : super(db);

  Future<void> initDefaultUser() async {
    final defaultUser = await (select(users)
      ..where((u) => u.username.equals('admin')))
        .getSingleOrNull();
    if (defaultUser == null) {
      await into(users).insert(
        UsersCompanion.insert(
          username: 'admin',
          password: 'admin123',
        ),
      );
    }
  }

  Future<bool> validateUser(String username, String password) async {
    final user = await (select(users)
      ..where(
              (u) => u.username.equals(username) & u.password.equals(password)))
        .getSingleOrNull();
    return user != null;
  }

  Future<String> changePassword(String username, String oldPassword, String newPassword,String securityQuestion,String securityAnswer) async {
    // 根据 username 找到对应实体类
    final user = await (select(users)
      ..where((u) => u.username.equals(username)))
        .getSingleOrNull();

    // 若用户不存在，返回错误信息
    if (user == null) {
      return 'user not found';
    }
    // 判断 oldPassword 是否等于实体类中的密码
    if (user.password != oldPassword) {
      return 'psw error';
    }
    // 修改实体类中密码，插入密保问题和答案
    await update(users)
      ..where((u) => u.username.equals(username))
      ..write(UsersCompanion(
        password: Value(newPassword),
        securityQuestion: Value(securityQuestion),
        securityAnswer: Value(securityAnswer),
      ));

    // 返回成功信息
    return 'success';
  }

  /**
   * 根据username获取用户信息
   *
   * @param username 要查询的用户的用户名
   * @return 返回一个 Future，包含查询到的用户信息。
   *         若用户不存在，抛出 StateError 异常。
   */
  Future<User?> getUserInfo(String username) async{
    // 构建查询语句，筛选出指定用户名的用户
    final user = await (select(users)
      ..where((u) => u.username.equals(username)))
        .getSingleOrNull();
    return user;
  }

  // 重置密码为 admin123
  Future<String> resetPsw(String username, String securityAnswer) async {
    // 根据 username 找到对应实体类
    final user = await (select(users)
      ..where((u) => u.username.equals(username)))
        .getSingleOrNull();

    // 若用户不存在，返回 false
    if (user == null) {
      return "user error";
    }

    // 判断之前 user 数据中是否有密保问题
    if (user.securityQuestion == null || user.securityQuestion!.isEmpty) {
      // 没有密保问题，直接重置
    } else {
      // 有密保问题，判断传入的答案和之前存储的答案是否相同
      if (user.securityAnswer != securityAnswer) {
        return "Security answer is incorrect";
      }
    }

    // 修改实体类中密码为 admin123
    final updateCount = await (update(users)
      ..where((u) => u.username.equals(username))
      ..write(UsersCompanion(
        password: Value('admin123'),
        securityQuestion: Value(''),
      )));

    return "ok";
  }

}