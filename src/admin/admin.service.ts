import common_1, {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { AdminRepo } from './admin.repo';

@Injectable()
export class AdminService {
  constructor(private readonly adminRepo: AdminRepo) {}

  async findAll() {
    // Gọi tới AdminRepo để lấy tất cả người dùng
    return this.adminRepo.findAll();
  }

  async findOne(id: number) {
    const user = await this.adminRepo.findById(id);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }

  async remove(id: number) {
    const user = await this.findOne(id); // Kiểm tra user tồn tại trước khi xóa
    if (!user) {
      throw new NotFoundException('User not found');
    }
    if (user.role === 'admin') {
      throw new BadRequestException('Cannot remove admin');
    }
    return this.adminRepo.remove(id);
  }

  async lock(id: number) {
    const user = await this.findOne(id);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    if (user.role === 'admin') {
      throw new BadRequestException('Cannot lock admin');
    }
    user.isActive = false; // Khóa tài khoản bằng cách đổi trạng thái
    return this.adminRepo.save(user);
  }
}
