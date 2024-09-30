import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';

@Injectable()
export class AdminRepo {
  constructor(@InjectRepository(User) private repo: Repository<User>) {}

  findById(id: number) {
    return this.repo.findOneBy({ id: id });
  }

  async findAll() {
    return this.repo.find(); // Lấy toàn bộ danh sách người dùng
  }

  remove(id: number) {
    return this.repo.delete(id);
  }

  save(user: User) {
    return this.repo.save(user);
  }
}
