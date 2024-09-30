import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { StaffRepo } from './staff.repo';

@Injectable()
export class StaffService {
  constructor(private readonly staffRepo: StaffRepo) {}

  async findAll() {
    return this.staffRepo.findAll({ role: 'user' });
  }

  async findOne(id: number) {
    const user = await this.staffRepo.findById(id);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    if (user.role === 'admin' || user.role === 'staff') {
      throw new BadRequestException('Cannot get admin or staff');
    }
    return user;
  }

  // Khóa một người dùng có role là "user"
  async lock(id: number) {
    const user = await this.findOne(id); // Kiểm tra user tồn tại và có role là "user" trước khi khóa
    if (!user) {
      throw new NotFoundException('User not found');
    }
    if (user.role === 'admin' || user.role === 'staff') {
      throw new BadRequestException('Cannot lock admin or staff');
    }
    user.isActive = false; // Khóa tài khoản bằng cách đổi trạng thái
    return this.staffRepo.save(user);
  }
}
