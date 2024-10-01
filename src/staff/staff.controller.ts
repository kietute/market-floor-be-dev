import { Controller, Get, Param, Put, UseGuards } from '@nestjs/common';
import { StaffGuard } from '../common/guards/staff.guard';
import { StaffService } from './staff.service';
import { Serialize } from '../common/interceptors/serialize.interceptor';
import { UserDto } from '../auth/dtos/user.dto';

@Controller('/staff')
@UseGuards(StaffGuard)
@Serialize(UserDto)
export class StaffController {
  constructor(private readonly adminService: StaffService) {}

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
}
