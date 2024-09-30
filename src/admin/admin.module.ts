import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { AdminController } from './admin.controller'; // Đúng đường dẫn tới AdminController
import { AdminService } from './admin.service'; // Import AdminService
import { AdminRepo } from './admin.repo'; // Import AdminRepo

@Module({
  imports: [TypeOrmModule.forFeature([User])], // Đảm bảo User entity được đăng ký với TypeORM
  exports: [AdminRepo],
  providers: [AdminService, AdminRepo], // Đăng ký AdminService và AdminRepo
  controllers: [AdminController], // Đăng ký AdminController
})
export class AdminModule {}
