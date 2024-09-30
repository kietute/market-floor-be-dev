import { Controller, Get, Param, Delete, Put, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminGuard } from '../common/guards/admin.guard';

@Controller('/admin')
@UseGuards(AdminGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get()
  getAll() {
    return this.adminService.findAll(); // Không cần tham số phân trang
  }

  @Get(':id')
  getUser(@Param('id') id: number) {
    return this.adminService.findOne(id);
  }

  @Put(':id/lock')
  lockUser(@Param('id') id: number) {
    return this.adminService.lock(id);
  }

  @Delete(':id')
  deleteUser(@Param('id') id: number) {
    return this.adminService.remove(id);
  }
}
