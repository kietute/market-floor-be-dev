import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { StaffRepo } from './staff.repo';
import { StaffService } from './staff.service';
import { StaffController } from './staff.controller'; // Đúng đường dẫn tới AdminController

@Module({
  imports: [TypeOrmModule.forFeature([User])], // Đảm bảo User entity được đăng ký với TypeORM
  exports: [StaffRepo],
  providers: [StaffService, StaffRepo], // Đăng ký AdminService và AdminRepo
  controllers: [StaffController], // Đăng ký AdminController
})
export class StaffModule {}
