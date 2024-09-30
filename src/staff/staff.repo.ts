import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user.entity'; // Giả định User entity đã có role

@Injectable()
export class StaffRepo {
  constructor(@InjectRepository(User) private repo: Repository<User>) {}

  // Lấy tất cả người dùng có role là "user"
  findAll(filter: { role: string }) {
    // @ts-expect-error
    return this.repo.find({ where: { role: filter.role } });
  }

  // Tìm một người dùng theo ID
  findById(id: number) {
    return this.repo.findOne({ where: { id } });
  }

  // Xóa người dùng
  remove(id: number) {
    return this.repo.delete({ id });
  }

  // Lưu người dùng (khi khóa)
  save(user: User) {
    return this.repo.save(user);
  }
}
